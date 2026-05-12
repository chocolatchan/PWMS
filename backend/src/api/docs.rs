use utoipa::{
    openapi::security::{HttpAuthScheme, HttpBuilder, SecurityScheme, ApiKey, ApiKeyValue},
    Modify, OpenApi,
};
use crate::models::dtos::*;
use crate::models::entities::QcDecision;
use crate::api::handlers::*;

#[derive(OpenApi)]
#[openapi(
    paths(
        handle_login,
        handle_receive_inbound,
        handle_submit_qc,
        handle_create_order,
        handle_scan_pick,
        handle_pack_container,
        handle_dispatch,
        handle_iot_temperature
    ),
    components(
        schemas(
            LoginReq,
            ReceiveInboundReq,
            BatchPayload,
            SubmitQcReq,
            QcDecision,
            CreateOrderReq,
            OrderItemPayload,
            ScanPickReq,
            PackContainerReq,
            DispatchReq,
            IotTemperatureReq
        )
    ),
    modifiers(&SecurityAddon),
    tags(
        (name = "Auth", description = "Authentication endpoints"),
        (name = "Inbound", description = "Warehouse Inbound & QC endpoints"),
        (name = "Outbound", description = "Order, Picking, Packing & Dispatch endpoints"),
        (name = "IoT", description = "IoT Cold Chain Tracking API")
    )
)]
pub struct ApiDoc;

struct SecurityAddon;

impl Modify for SecurityAddon {
    fn modify(&self, openapi: &mut utoipa::openapi::OpenApi) {
        if let Some(components) = openapi.components.as_mut() {
            components.add_security_scheme(
                "jwt",
                SecurityScheme::Http(
                    HttpBuilder::new()
                        .scheme(HttpAuthScheme::Bearer)
                        .bearer_format("JWT")
                        .build(),
                ),
            );
            
            components.add_security_scheme(
                "api_key",
                SecurityScheme::ApiKey(
                    ApiKey::Header(
                        ApiKeyValue::new("X-API-Key")
                    )
                ),
            );
        }
    }
}


