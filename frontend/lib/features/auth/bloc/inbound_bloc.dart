import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwms_frontend/features/inbound/bloc/inbound_event.dart';
import 'package:pwms_frontend/features/inbound/bloc/inbound_state.dart';
import 'package:pwms_frontend/features/inbound/data/inbound_repository.dart';

class InboundBloc extends Bloc<InboundEvent, InboundState> {
  final InboundRepository _repository;

  InboundBloc(this._repository) : super(InboundInitial()) {
    on<FetchReceipts>(_onFetchReceipts);
    on<SubmitBatchInfo>(_onSubmitBatchInfo);
  }

  Future<void> _onFetchReceipts(
    FetchReceipts event,
    Emitter<InboundState> emit,
  ) async {
    emit(InboundLoading());
    try {
      final receipts = await _repository.getPendingReceipts();
      emit(ReceiptsLoaded(receipts));
    } catch (e) {
      emit(InboundFailure(e.toString()));
    }
  }

  Future<void> _onSubmitBatchInfo(
    SubmitBatchInfo event,
    Emitter<InboundState> emit,
  ) async {
    // 1. Validation Logic trước khi gửi đi
    final mfg = DateTime.parse(event.request.manufactureDate);
    final exp = DateTime.parse(event.request.expiryDate);

    if (exp.isBefore(mfg)) {
      emit(const InboundFailure("Hạn dùng không được trước ngày sản xuất"));
      return;
    }

    emit(InboundLoading());
    try {
      await _repository.submitInboundItem(event.request);
      emit(const InboundSuccess("Khai báo lô hàng thành công"));
    } on InboundException catch (e) {
      // Bẫy nghiệp vụ Missing COA đã làm ở Repository
      emit(InboundFailure(e.message));
    } catch (e) {
      emit(InboundFailure(e.toString()));
    }
  }
}
