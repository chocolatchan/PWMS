import 'package:equatable/equatable.dart';
import '../models/inbound_models.dart';

abstract class InboundState extends Equatable {
  const InboundState();
  @override
  List<Object?> get props => [];
}

class InboundInitial extends InboundState {}

class InboundLoading extends InboundState {}

class ReceiptsLoaded extends InboundState {
  final List<InboundReceiptDto> receipts;
  const ReceiptsLoaded(this.receipts);
  @override
  List<Object?> get props => [receipts];
}

class PartnersLoaded extends InboundState {
  final List<PartnerDto> partners;
  const PartnersLoaded(this.partners);
  @override
  List<Object?> get props => [partners];
}

class ProcessingItem extends InboundState {
  final InboundDetailDto item;
  const ProcessingItem(this.item);
  @override
  List<Object?> get props => [item];
}

class InboundSuccess extends InboundState {
  final String message;
  final int? receiptId;
  const InboundSuccess(this.message, {this.receiptId});
  @override
  List<Object?> get props => [message, receiptId];
}

class InboundFailure extends InboundState {
  final String error;
  const InboundFailure(this.error);
  @override
  List<Object?> get props => [error];
}
