use bcrypt::verify;

fn main() {
    let password = "password";
    let hash = "$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi";
    match verify(password, hash) {
        Ok(true) => println!("Hash is VALID"),
        Ok(false) => println!("Hash is INVALID"),
        Err(e) => println!("Error: {:?}", e),
    }
}
