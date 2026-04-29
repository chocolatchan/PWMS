CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    cccd VARCHAR(20) UNIQUE,
    phone VARCHAR(20),
    birth_date DATE,
    start_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(employee_id),
    role_id INTEGER REFERENCES roles(role_id),
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);
