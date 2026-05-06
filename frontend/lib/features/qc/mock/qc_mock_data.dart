// ============================================================
// FILE: qc_mock_data.dart
// Static QRN- items sent from Inbound. No backend calls.
// ============================================================

enum QcReason { missingDocs, physicalDamage, temperatureExcursion }

extension QcReasonLabel on QcReason {
  String get label {
    switch (this) {
      case QcReason.missingDocs:          return 'Thiếu hồ sơ (MISSING_DOCS)';
      case QcReason.physicalDamage:       return 'Hư hỏng vật lý (PHYSICAL_DAMAGE)';
      case QcReason.temperatureExcursion: return 'Nhiệt độ vượt ngưỡng (TEMP_EXCURSION)';
    }
  }

  String get code {
    switch (this) {
      case QcReason.missingDocs:          return 'MISSING_DOCS';
      case QcReason.physicalDamage:       return 'PHYSICAL_DAMAGE';
      case QcReason.temperatureExcursion: return 'TEMP_EXCURSION';
    }
  }
}

class QcItem {
  final int id;
  final String toteCode;       // always starts with QRN-
  final String productCode;
  final String productName;
  final String batchNumber;
  final String manufacturer;
  final int declaredQty;
  final String unit;
  final QcReason reason;
  final DateTime receivedAt;

  const QcItem({
    required this.id,
    required this.toteCode,
    required this.productCode,
    required this.productName,
    required this.batchNumber,
    required this.manufacturer,
    required this.declaredQty,
    required this.unit,
    required this.reason,
    required this.receivedAt,
  });
}

class QcMockData {
  static final List<QcItem> pendingItems = [
    QcItem(
      id: 1,
      toteCode: 'QRN-001',
      productCode: 'P001',
      productName: 'Paracetamol 500mg',
      batchNumber: 'L042/24',
      manufacturer: 'DHG Pharma',
      declaredQty: 200,
      unit: 'Hộp',
      reason: QcReason.missingDocs,
      receivedAt: DateTime(2026, 5, 6, 8, 30),
    ),
    QcItem(
      id: 2,
      toteCode: 'QRN-002',
      productCode: 'P099',
      productName: 'Morphine Sulfate 10mg/mL',
      batchNumber: 'M007/24',
      manufacturer: 'Mega Lifesciences',
      declaredQty: 30,
      unit: 'Hộp',
      reason: QcReason.physicalDamage,
      receivedAt: DateTime(2026, 5, 6, 9, 15),
    ),
    QcItem(
      id: 3,
      toteCode: 'QRN-003',
      productCode: 'P055',
      productName: 'Insulin Glargine 100U/mL',
      batchNumber: 'IG019/24',
      manufacturer: 'Sanofi',
      declaredQty: 50,
      unit: 'Lọ',
      reason: QcReason.temperatureExcursion,
      receivedAt: DateTime(2026, 5, 6, 10, 0),
    ),
  ];
}
