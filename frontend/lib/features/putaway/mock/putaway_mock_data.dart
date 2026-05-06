// ============================================================
// FILE: putaway_mock_data.dart
// Static hardcoded Putaway tasks — NO backend calls.
// ============================================================

class PutawayTote {
  final String toteCode;
  final String productCode;
  final String productName;
  final String batchNumber;
  final int qty;
  final String unit;
  final String suggestedLocation;
  final String alternateLocation;
  final bool isToxic;

  const PutawayTote({
    required this.toteCode,
    required this.productCode,
    required this.productName,
    required this.batchNumber,
    required this.qty,
    required this.unit,
    required this.suggestedLocation,
    required this.alternateLocation,
    required this.isToxic,
  });
}

class PutawayMockData {
  static const List<PutawayTote> totes = [
    PutawayTote(
      toteCode: 'STD-001',
      productCode: 'P001',
      productName: 'Paracetamol 500mg',
      batchNumber: 'L042/24',
      qty: 200,
      unit: 'Hộp',
      suggestedLocation: 'AVL-001',
      alternateLocation: 'AVL-002',
      isToxic: false,
    ),
    PutawayTote(
      toteCode: 'TOX-999',
      productCode: 'P099',
      productName: 'Morphine Sulfate 10mg/mL',
      batchNumber: 'M007/24',
      qty: 30,
      unit: 'Hộp',
      suggestedLocation: 'TOX-001',
      alternateLocation: 'TOX-002',
      isToxic: true,
    ),
  ];

  static PutawayTote? findByCode(String code) {
    try {
      return totes.firstWhere(
        (t) => t.toteCode.toLowerCase() == code.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
