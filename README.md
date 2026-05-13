# Pharma WMS V2 - Deployment & Configuration Guide

This document provides instructions for the IT department to build, install, and configure the Pharma Warehouse Management System (PWMS) in a local network environment.

[![Demo Video](https://img.shields.io/badge/Demo-Video-red?style=for-the-badge&logo=google-drive)](https://drive.google.com/drive/folders/1B-GvhLb_BdoZSb7z6-fuUgTWRkYyz-hi?usp=sharing)

## 📋 System Requirements
- **OS**: Linux (Ubuntu 22.04+ recommended)
- **Runtime**: Docker & Docker Compose
- **Backend**: Rust 1.75+
- **Frontend**: Flutter 3.16+ (FVM recommended)
- **Database**: PostgreSQL 15+ (Containerized)

---

## 🏗️ 1. Backend Setup (Server)

### 1.1 Database Initialization
The system uses PostgreSQL. Ensure Docker is running, then initialize the database:
```bash
# Start the database container
make db-start

# Run migrations and seed initial data
make reset-db && make seed
```

### 1.2 Backend Configuration
Create a `.env` file in the root directory:
```env
DATABASE_URL=postgres://pharma_admin:pharma_secret_123@localhost:5432/wms_pharma_dev
JWT_SECRET=your_secure_random_string_here
API_IP=0.0.0.0
SERVER_PORT=3000
```

### 1.3 Running the Backend
```bash
# Open port 3000 in firewall and start the server
make be-run
```

---

## 📱 2. Frontend Setup (Client Apps/PDA)

### 2.1 Building for Android (PDA Devices)
The frontend must be pointed to the server's LAN IP. The build process automatically detects your host IP, but you can override it:

```bash
# Build APK with specific server IP
flutter build apk --dart-define=API_IP=192.168.1.XX
```

### 2.2 Environment File
The app reads `frontend/.env` for runtime configuration. Ensure `API_URL` matches your server's LAN address:
```env
API_URL=http://192.168.1.XX:3000/api/v2/
```

---

## 🌐 3. Network & IP Configuration (Crucial)

For PDA devices and other workstations to communicate with the server, follow these steps:

### 3.1 Static IP Assignment
It is **highly recommended** to assign a Static IP to the server machine (e.g., `192.168.1.50`) via your router's DHCP reservation.

### 3.2 Firewall Configuration
The server must allow inbound traffic on port `3000`. Our `Makefile` attempts to handle this automatically for `firewalld`:
```bash
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload
```

### 3.3 Dynamic IP Detection
If the server's IP changes, you can use the built-in detection tool to verify the current listening address:
```bash
make be-run
# Look for the log: "Backend is public on LAN: 192.168.1.XX:3000"
```

---

## 🛠️ 4. Maintenance Commands

| Command | Description |
|---------|-------------|
| `make reset-db` | Wipes and recreates the database schema |
| `make seed` | Re-seeds the database with default users and products |
| `docker logs -f pwms_postgres` | View database logs |
| `tail -f server.log` | View backend application logs |

---

## 🔐 Default Credentials
| Username | Password | Role |
|----------|----------|------|
| `admin01` | `admin123` | Administrator |
| `picker01` | `admin123` | Warehouse Staff |

> [!CAUTION]
> Ensure you change the `JWT_SECRET` and default passwords before moving to a production environment.
