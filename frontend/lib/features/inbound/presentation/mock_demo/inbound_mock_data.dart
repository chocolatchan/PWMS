// ============================================================
// FILE: inbound_mock_data.dart
// Mock PO data - NO backend calls, fully self-contained.
// ============================================================

/// Represents a single Purchase Order line item with all
/// metadata needed to enforce GSP business rules locally.
class MockPoItem {
  final int id;
  final String productCode;
  final String productName;
  final String activeIngredient;
  final String dosageForm;
  final String baseUnit;
  final String purchaseUnit;  // e.g. "Hộp"
  final double conversionRate; // 1 Hộp = conversionRate Viên
  final int expectedQty;       // In purchaseUnit
  final bool isToxic;
  final bool isLasa;

  const MockPoItem({
    required this.id,
    required this.productCode,
    required this.productName,
    required this.activeIngredient,
    required this.dosageForm,
    required this.baseUnit,
    required this.purchaseUnit,
    required this.conversionRate,
    required this.expectedQty,
    required this.isToxic,
    required this.isLasa,
  });

  MockPoItem copyWith({
    int? id,
    String? productCode,
    String? productName,
    String? activeIngredient,
    String? dosageForm,
    String? baseUnit,
    String? purchaseUnit,
    double? conversionRate,
    int? expectedQty,
    bool? isToxic,
    bool? isLasa,
  }) {
    return MockPoItem(
      id: id ?? this.id,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      activeIngredient: activeIngredient ?? this.activeIngredient,
      dosageForm: dosageForm ?? this.dosageForm,
      baseUnit: baseUnit ?? this.baseUnit,
      purchaseUnit: purchaseUnit ?? this.purchaseUnit,
      conversionRate: conversionRate ?? this.conversionRate,
      expectedQty: expectedQty ?? this.expectedQty,
      isToxic: isToxic ?? this.isToxic,
      isLasa: isLasa ?? this.isLasa,
    );
  }
}

class InboundMockData {
  static const List<MockPoItem> poItems = [
    MockPoItem(
      id: 1,
      productCode: 'P001',
      productName: 'Paracetamol 500mg',
      activeIngredient: 'Paracetamol',
      dosageForm: 'Viên nén',
      baseUnit: 'Viên',
      purchaseUnit: 'Hộp',
      conversionRate: 100.0, // 1 Hộp = 100 Viên
      expectedQty: 500,       // 500 Hộp
      isToxic: false,
      isLasa: false,
    ),
    MockPoItem(
      id: 2,
      productCode: 'P002',
      productName: 'Amoxicillin 500mg',
      activeIngredient: 'Amoxicillin',
      dosageForm: 'Viên nén',
      baseUnit: 'Viên',
      purchaseUnit: 'Hộp',
      conversionRate: 10.0,
      expectedQty: 300,
      isToxic: false,
      isLasa: false,
    ),
    MockPoItem(
      id: 3,
      productCode: 'P099',
      productName: 'Morphine Sulfate 10mg/mL',
      activeIngredient: 'Morphine Sulfate',
      dosageForm: 'Dung dịch tiêm',
      baseUnit: 'Ống',
      purchaseUnit: 'Hộp',
      conversionRate: 10.0, // 1 Hộp = 10 Ống
      expectedQty: 50,       // 50 Hộp
      isToxic: true,
      isLasa: true,
    ),
  ];

  static const List<String> manufacturers = [
    'DHG Pharma',
    'Traphaco',
    'Mega Lifesciences',
    'AstraZeneca',
    'Sanofi',
    'Imexpharm',
  ];
}
