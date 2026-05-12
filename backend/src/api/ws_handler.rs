use crate::models::dtos::OutboxEventMessage;
use crate::services::auth_service::AuthService;
use axum::{
    extract::{
        ws::{Message, WebSocket, WebSocketUpgrade},
        State,
    },
    response::IntoResponse,
};
use futures::{sink::SinkExt, stream::StreamExt};
use serde::{Deserialize, Serialize};
use tokio::sync::broadcast;
use tokio::time::{timeout, Duration};

#[derive(Debug, Deserialize)]
#[serde(tag = "type")]
enum WsAuthMessage {
    #[serde(rename = "auth")]
    Auth { token: String },
}

#[derive(Debug, Serialize)]
struct WsErrorMessage {
    error: String,
}

pub async fn handle_ws(
    ws: WebSocketUpgrade,
    State(event_tx): State<broadcast::Sender<OutboxEventMessage>>,
) -> impl IntoResponse {
    ws.on_upgrade(move |socket| handle_socket(socket, event_tx))
}

async fn handle_socket(mut socket: WebSocket, event_tx: broadcast::Sender<OutboxEventMessage>) {
    // 1. First Message Auth Flow
    let auth_timeout = Duration::from_secs(5);

    let claims = match timeout(auth_timeout, socket.next()).await {
        Ok(Some(Ok(Message::Text(text)))) => match serde_json::from_str::<WsAuthMessage>(&text) {
            Ok(WsAuthMessage::Auth { token }) => match AuthService::verify_token(&token) {
                Ok(claims) => claims,
                Err(_) => {
                    let _ = socket
                        .send(Message::Text(
                            serde_json::to_string(&WsErrorMessage {
                                error: "Invalid token".into(),
                            })
                            .unwrap(),
                        ))
                        .await;
                    return;
                }
            },
            Err(_) => {
                let _ = socket
                    .send(Message::Text(
                        serde_json::to_string(&WsErrorMessage {
                            error: "Invalid auth message format".into(),
                        })
                        .unwrap(),
                    ))
                    .await;
                return;
            }
        },
        _ => {
            let _ = socket
                .send(Message::Text(
                    serde_json::to_string(&WsErrorMessage {
                        error: "Authentication timeout or invalid initial message".into(),
                    })
                    .unwrap(),
                ))
                .await;
            return;
        }
    };

    tracing::info!(
        "🔌 WebSocket client authenticated: {} ({})",
        claims.username,
        claims.sub
    );

    // 2. Main Broadcast Loop (Live Only Approach)
    let mut rx = event_tx.subscribe();
    let (mut sender, mut receiver) = socket.split();

    let mut send_task = tokio::spawn(async move {
        loop {
            tokio::select! {
                msg = rx.recv() => {
                    match msg {
                        Ok(event) => {
                            let json = serde_json::to_string(&event).unwrap();
                            if let Err(e) = sender.send(Message::Text(json)).await {
                                tracing::error!("WebSocket send error: {:?}", e);
                                break;
                            }
                        }
                        Err(broadcast::error::RecvError::Lagged(n)) => {
                            tracing::warn!("WebSocket client lagged by {} events", n);
                            // Continue to most recent event
                            continue;
                        }
                        Err(broadcast::error::RecvError::Closed) => {
                            break;
                        }
                    }
                }
            }
        }
    });

    // Handle client disconnect or incoming messages (we only expect Pongs or Close)
    let mut recv_task = tokio::spawn(async move {
        while let Some(Ok(msg)) = receiver.next().await {
            if let Message::Close(_) = msg {
                break;
            }
        }
    });

    // If either task finishes, abort the other and exit
    tokio::select! {
        _ = (&mut send_task) => recv_task.abort(),
        _ = (&mut recv_task) => send_task.abort(),
    };

    tracing::info!("🔌 WebSocket client disconnected: {}", claims.username);
}
