import 'package:pwms_frontend/features/inbound/data/models/inbound_models.dart';

class InboundState {
  final PurchaseOrder? currentPo;
  final String? toteBarcode;

  const InboundState({
    this.currentPo,
    this.toteBarcode,
  });

  // Mock toJson for compatibility
  Map<String, dynamic> toJson() => {};
}
