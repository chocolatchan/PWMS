import 'admin_models.dart';

class AdminMockData {
  static const KpiMetrics defaultMetrics = KpiMetrics(
    ordersPendingPick: 24,
    itemsInQuarantine: 5,
    dispatchRate: '98%',
    criticalAlerts: 1, // 1 Temp Violation
  );

  static const List<AuditLogEvent> happyPath = [
    AuditLogEvent(
      id: 'EVT-1001',
      timestamp: '05-May-2026 08:30:15',
      actionName: 'Inbound Receipt',
      userResponsible: 'Nhân viên: inbound01 (Nguyễn Văn A)',
      details: 'Nhận 500 hộp từ NCC PharmaCorp vào TOTE-001',
      isSuccess: true,
    ),
    AuditLogEvent(
      id: 'EVT-1002',
      timestamp: '05-May-2026 09:15:22',
      actionName: 'QA Approval',
      userResponsible: 'Dược sĩ: qa01 (Trần Thị B)',
      details: 'Kiểm tra đạt tiêu chuẩn GSP. E-Sign xác nhận.',
      isSuccess: true,
    ),
    AuditLogEvent(
      id: 'EVT-1003',
      timestamp: '05-May-2026 10:05:10',
      actionName: 'Putaway Drop',
      userResponsible: 'Nhân viên: putaway01 (Lê Văn C)',
      details: 'Cất TOTE-001 lên kệ AVL-001 theo FEFO.',
      isSuccess: true,
    ),
    AuditLogEvent(
      id: 'EVT-1004',
      timestamp: '05-May-2026 14:20:05',
      actionName: 'Picking Execution',
      userResponsible: 'Nhân viên: picker01 (Phạm Văn D)',
      details: 'Lấy 20 hộp cho đơn SO-999 vào rổ STD-123.',
      isSuccess: true,
    ),
    AuditLogEvent(
      id: 'EVT-1005',
      timestamp: '05-May-2026 15:45:30',
      actionName: 'Dispatch Check',
      userResponsible: 'Điều phối: dispatch01 (Hoàng Thị E)',
      details: 'Đóng seal SEAL-999. Kiểm tra nhiệt độ xe: 5.5°C. Đã xuất cổng.',
      isSuccess: true,
    ),
  ];

  static const List<AuditLogEvent> rejectedPath = [
    AuditLogEvent(
      id: 'EVT-2001',
      timestamp: '05-May-2026 08:30:15',
      actionName: 'Inbound Receipt',
      userResponsible: 'Nhân viên: inbound01 (Nguyễn Văn A)',
      details: 'Nhận 200 hộp từ NCC XYZ vào TOTE-ERR',
      isSuccess: true,
    ),
    AuditLogEvent(
      id: 'EVT-2002',
      timestamp: '05-May-2026 09:40:00',
      actionName: 'QA Rejected',
      userResponsible: 'Dược sĩ: qa01 (Trần Thị B)',
      details: 'Từ chối: Thiếu giấy COA, bao bì móp méo.',
      isSuccess: false,
    ),
    AuditLogEvent(
      id: 'EVT-2003',
      timestamp: '05-May-2026 10:15:30',
      actionName: 'Quarantine Drop',
      userResponsible: 'Nhân viên: putaway01 (Lê Văn C)',
      details: 'Đưa TOTE-ERR vào khu biệt trữ (Quarantine).',
      isSuccess: true,
    ),
    AuditLogEvent(
      id: 'EVT-2004',
      timestamp: '06-May-2026 08:00:00',
      actionName: 'Destroy Zone Relocation',
      userResponsible: 'Quản lý: admin01 (Phạm Văn F)',
      details: 'Quyết định tiêu hủy. Chuyển sang khu Z-REJ chờ xử lý.',
      isSuccess: false, // Marking red to indicate bad ending
    ),
  ];
}
