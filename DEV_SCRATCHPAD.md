# 🛠️ PWMS Development Scratchpad

This document serves as a central reference for the current development state, credentials, and configuration.

## 🌐 Network Configuration
| Service | URL / IP | Status |
|---------|----------|--------|
| **Backend API** | `http://10.207.125.177:3000/api/v2/` | 🟢 Running |
| **WebSocket** | `ws://10.207.125.177:3000/api/v2/ws` | 🟠 Fixed Typo |
| **Database** | `localhost:5432 (wms_pharma_dev)` | 🟢 Seeded |

> [!IMPORTANT]
> Your LAN IP seems to have changed to **10.207.125.177**. 
> Always use `make be-run` first to see the current IP.

## 🔐 Credentials (admin123)
| Role | Username | Password |
|------|----------|----------|
| **Admin** | `admin01` | `admin123` |
| **QA** | `qa01` | `admin123` |
| **Inbound** | `inbound01` | `admin123` |
| **Picker** | `picker01` | `admin123` |

## 🚀 Quick Commands
```bash
# 1. Reset everything (Warning: deletes all data)
make reset-db && make seed

# 2. Run Backend (opens port automatically)
make be-run

# 3. Run Frontend
make fe-dev
```

## ✅ Feature Checklist
- [x] **Authentication**: Working with `admin123`
- [x] **Inbound PO**: Manual entry and batch adjustment
- [x] **Barcoding**: `Amoxicillin 250mg` fixed (Barcode: `08930000000003`)
- [x] **Environment**: `.env` correctly loaded by Flutter
- [x] **Real-time**: WebSocket IP resolution fixed
