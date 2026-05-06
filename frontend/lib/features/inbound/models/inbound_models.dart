import 'package:equatable/equatable.dart';

class PartnerDto extends Equatable {
  final int id;
  final String name;
  final String? taxCode;

  const PartnerDto({
    required this.id,
    required this.name,
    this.taxCode,
  });

  factory PartnerDto.fromJson(Map<String, dynamic> json) {
    return PartnerDto(
      id: json['id'] as int,
      name: json['name'] as String,
      taxCode: json['tax_code'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, taxCode];
}

class InboundReceiptDto extends Equatable {
  final int id;
  final String receiptNumber;
  final int supplierId;
  final String supplierName;
  final DateTime receiptDate;
  final String status;
  final DateTime createdAt;

  const InboundReceiptDto({
    required this.id,
    required this.receiptNumber,
    required this.supplierId,
    required this.supplierName,
    required this.receiptDate,
    required this.status,
    required this.createdAt,
  });

  factory InboundReceiptDto.fromJson(Map<String, dynamic> json) {
    return InboundReceiptDto(
      id: json['id'] as int,
      receiptNumber: json['receipt_number'] as String,
      supplierId: json['supplier_id'] as int,
      supplierName: json['supplier_name'] as String,
      receiptDate: DateTime.parse(json['receipt_date'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'receipt_number': receiptNumber,
        'supplier_id': supplierId,
        'receipt_date': receiptDate.toIso8601String().split('T')[0],
      };

  @override
  List<Object?> get props => [
        id,
        receiptNumber,
        supplierId,
        supplierName,
        receiptDate,
        status,
        createdAt,
      ];
}

class InboundDetailDto extends Equatable {
  final int id;
  final int productId;
  final String productCode;
  final String productName;
  final String? dosageForm;
  final String? packaging;
  final int expectedQty;
  final int receivedQty;

  const InboundDetailDto({
    required this.id,
    required this.productId,
    required this.productCode,
    required this.productName,
    this.dosageForm,
    this.packaging,
    required this.expectedQty,
    required this.receivedQty,
  });

  factory InboundDetailDto.fromJson(Map<String, dynamic> json) {
    return InboundDetailDto(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      productCode: json['product_code'] as String,
      productName: json['product_name'] as String,
      dosageForm: json['dosage_form'] as String?,
      packaging: json['packaging'] as String?,
      expectedQty: json['expected_qty'] as int,
      receivedQty: json['received_qty'] as int,
    );
  }

  @override
  List<Object?> get props => [id, productId, productCode, productName, dosageForm, packaging, expectedQty, receivedQty];
}

class InboundItemRequest extends Equatable {
  final int receiptId;
  final int productId;
  final String batchNumber;
  final String manufactureDate;
  final String expiryDate;
  final int declaredQty;
  final String toteCode;
  final bool isCoaAvailable;
  final String? gateNote;
  final int? quarantineLocationId;

  const InboundItemRequest({
    required this.receiptId,
    required this.productId,
    required this.batchNumber,
    required this.manufactureDate,
    required this.expiryDate,
    required this.declaredQty,
    required this.toteCode,
    required this.isCoaAvailable,
    this.gateNote,
    this.quarantineLocationId,
  });

  Map<String, dynamic> toJson() => {
        'receipt_id': receiptId,
        'product_id': productId,
        'batch_number': batchNumber,
        'manufacture_date': manufactureDate,
        'expiry_date': expiryDate,
        'declared_qty': declaredQty,
        'tote_code': toteCode,
        'is_coa_available': isCoaAvailable,
        'gate_note': gateNote,
        'quarantine_location_id': quarantineLocationId,
      };

  @override
  List<Object?> get props => [
        receiptId,
        productId,
        batchNumber,
        manufactureDate,
        expiryDate,
        declaredQty,
        toteCode,
        isCoaAvailable,
        gateNote,
        quarantineLocationId,
      ];
}
