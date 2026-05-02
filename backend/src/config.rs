use std::env;

#[derive(Debug, Clone)]
pub struct Config {
    pub database_url: String,
    pub server_port: u16,
    pub jwt_secret: String,
}

impl Config {
    pub fn load() -> Self {
        // Try to load .env file if it exists, but don't fail if it doesn't
        // (e.g., in production where env vars are set directly)
        let _ = dotenvy::dotenv();

        let database_url = env::var("DATABASE_URL")
            .expect("DATABASE_URL must be set in environment or .env");
        
        let server_port = env::var("PORT")
            .unwrap_or_else(|_| "3001".to_string())
            .parse::<u16>()
            .expect("PORT must be a valid u16");

        let jwt_secret = env::var("JWT_SECRET")
            .unwrap_or_else(|_| "super_secret_key_change_in_production".to_string());

        Config {
            database_url,
            server_port,
            jwt_secret,
        }
    }
}
