import 'package:equatable/equatable.dart';
import '../models/inbound_models.dart';

abstract class InboundEvent extends Equatable {
  const InboundEvent();
  @override
  List<Object?> get props => [];
}

class FetchReceipts extends InboundEvent {}

class LoadPartners extends InboundEvent {}

class CreateReceiptRequested extends InboundEvent {
  final InboundReceiptDto receipt;
  const CreateReceiptRequested(this.receipt);
  @override
  List<Object?> get props => [receipt];
}

class SelectReceipt extends InboundEvent {
  final int receiptId;
  const SelectReceipt(this.receiptId);
  @override
  List<Object?> get props => [receiptId];
}

class ScanItem extends InboundEvent {
  final String barcode;
  const ScanItem(this.barcode);
  @override
  List<Object?> get props => [barcode];
}

class SubmitBatchInfo extends InboundEvent {
  final InboundItemRequest request;
  const SubmitBatchInfo(this.request);
  @override
  List<Object?> get props => [request];
}

class FinishReceiptRequested extends InboundEvent {
  final int receiptId;
  const FinishReceiptRequested(this.receiptId);
  @override
  List<Object?> get props => [receiptId];
}
