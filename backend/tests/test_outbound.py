import pytest
import requests

# --- MOCK DATA ---
BASE_URL = "http://localhost:3001" # Server chạy tại 3001 theo log trước đó
MOCK_TASK_ID = 1
MOCK_ORDER_ID = 1
MOCK_PRODUCT_ID = 1
MOCK_TOTE = "TOTE-001"
MOCK_BATCH_ID = 1
MOCK_LOCATION_ID = 1
RECALLED_BATCH_ID = 99  # Giả định ID này bị Recalled trong DB

@pytest.fixture
def api_client():
    session = requests.Session()
    session.headers.update({"Content-Type": "application/json"})
    return session

def test_1_start_task_success(api_client):
    """Test 1: Happy Path - Khóa Rổ (Tote Lock)"""
    payload = {
        "task_id": MOCK_TASK_ID,
        "tote_code": MOCK_TOTE
    }
    response = api_client.post(f"{BASE_URL}/api/picking/start", json=payload)
    assert response.status_code == 200
    assert "success" in response.text.lower()

def test_2_submit_pick_success(api_client):
    """Test 2: Happy Path - Nhặt hàng thành công"""
    payload = {
        "task_id": MOCK_TASK_ID,
        "order_id": MOCK_ORDER_ID,
        "product_id": MOCK_PRODUCT_ID,
        "batch_id": MOCK_BATCH_ID,
        "location_id": MOCK_LOCATION_ID,
        "qty": 1
    }
    response = api_client.post(f"{BASE_URL}/api/picking/submit", json=payload)
    assert response.status_code == 200
    assert "success" in response.text.lower()

def test_3_circuit_breaker_recalled(api_client):
    """Test 3: Negative - Circuit Breaker chặn hàng thu hồi"""
    payload = {
        "task_id": MOCK_TASK_ID,
        "order_id": MOCK_ORDER_ID,
        "product_id": MOCK_PRODUCT_ID,
        "batch_id": RECALLED_BATCH_ID,
        "location_id": MOCK_LOCATION_ID,
        "qty": 1
    }
    response = api_client.post(f"{BASE_URL}/api/picking/submit", json=payload)
    assert response.status_code == 400
    assert "circuit" in response.text.lower()

def test_4_overpick_error(api_client):
    """Test 4: Negative - Overpick (Vượt quá tồn kho)"""
    payload = {
        "task_id": MOCK_TASK_ID,
        "order_id": MOCK_ORDER_ID,
        "product_id": MOCK_PRODUCT_ID,
        "batch_id": MOCK_BATCH_ID,
        "location_id": MOCK_LOCATION_ID,
        "qty": 9999
    }
    response = api_client.post(f"{BASE_URL}/api/picking/submit", json=payload)
    assert response.status_code == 400
    assert "không đủ" in response.text.lower() or "qty" in response.text.lower() or "quantity" in response.text.lower()
