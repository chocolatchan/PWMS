use axum::{
    extract::{
        ws::{Message, WebSocket, WebSocketUpgrade},
        State,
    },
    response::IntoResponse,
};
use crate::state::SharedState;

pub async fn ws_handler(
    ws: WebSocketUpgrade,
    State(state): State<SharedState>,
) -> impl IntoResponse {
    ws.on_upgrade(move |socket| handle_socket(socket, state))
}

async fn handle_socket(mut socket: WebSocket, state: SharedState) {
    let mut rx = state.ws_sender.subscribe();

    // In a real application, you might want to handle incoming messages from the client as well.
    // Here we focus on pushing updates (server-to-client).
    while let Ok(msg) = rx.recv().await {
        if let Ok(json_str) = serde_json::to_string(&msg) {
            if socket.send(Message::Text(json_str.into())).await.is_err() {
                // Client disconnected
                break;
            }
        }
    }
}
