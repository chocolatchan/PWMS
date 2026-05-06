import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/hardware/audio_service.dart';
import '../../../core/hardware/haptic_service.dart';
import '../data/inbound_repository.dart';
import '../models/inbound_models.dart';
import 'inbound_event.dart';
import 'inbound_state.dart';

class InboundBloc extends Bloc<InboundEvent, InboundState> {
  final InboundRepository _repository;
  final AudioService _audioService;
  final HapticService _hapticService;

  List<InboundDetailDto> _currentDetails = [];

  InboundBloc(
    this._repository,
    this._audioService,
    this._hapticService,
  ) : super(InboundInitial()) {
    on<FetchReceipts>(_onFetchReceipts);
    on<LoadPartners>(_onLoadPartners);
    on<CreateReceiptRequested>(_onCreateReceipt);
    on<SelectReceipt>(_onSelectReceipt);
    on<ScanItem>(_onScanItem);
    on<SubmitBatchInfo>(_onSubmitBatchInfo);
    on<FinishReceiptRequested>(_onFinishReceipt);
  }

  Future<void> _onFetchReceipts(FetchReceipts event, Emitter<InboundState> emit) async {
    emit(InboundLoading());
    try {
      final receipts = await _repository.getPendingReceipts();
      emit(ReceiptsLoaded(receipts));
    } catch (e) {
      emit(InboundFailure(e.toString()));
    }
  }

  Future<void> _onLoadPartners(LoadPartners event, Emitter<InboundState> emit) async {
    emit(InboundLoading());
    try {
      final partners = await _repository.getPartners();
      emit(PartnersLoaded(partners));
    } catch (e) {
      emit(InboundFailure(e.toString()));
    }
  }

  Future<void> _onCreateReceipt(CreateReceiptRequested event, Emitter<InboundState> emit) async {
    emit(InboundLoading());
    try {
      final receipt = await _repository.createReceipt(event.receipt);
      emit(InboundSuccess("Đã tạo phiếu #${receipt.receiptNumber}", receiptId: receipt.id));
    } catch (e) {
      emit(InboundFailure(e.toString()));
    }
  }

  Future<void> _onSelectReceipt(SelectReceipt event, Emitter<InboundState> emit) async {
    emit(InboundLoading());
    try {
      _currentDetails = await _repository.getReceiptDetails(event.receiptId);
      emit(InboundSuccess("Đã tải chi tiết phiếu #${event.receiptId}"));
    } catch (e) {
      emit(InboundFailure(e.toString()));
    }
  }

  void _onScanItem(ScanItem event, Emitter<InboundState> emit) {
    try {
      // Logic quét mã thuốc (product_code)
      final item = _currentDetails.firstWhere(
        (d) => d.productCode == event.barcode,
        orElse: () => throw Exception("Sản phẩm [${event.barcode}] không có trong hóa đơn này!"),
      );
      
      _hapticService.vibrateSuccess();
      emit(ProcessingItem(item));
    } catch (e) {
      _audioService.playError();
      _hapticService.vibrateError();
      emit(InboundFailure(e.toString()));
    }
  }

  Future<void> _onSubmitBatchInfo(SubmitBatchInfo event, Emitter<InboundState> emit) async {
    emit(InboundLoading());
    try {
      final mfg = DateTime.parse(event.request.manufactureDate);
      
      if (event.request.expiryDate.isEmpty) {
        throw Exception("Hạn dùng (Expiration Date) là bắt buộc!");
      }
      final exp = DateTime.parse(event.request.expiryDate);
      
      if (exp.isBefore(mfg)) {
        throw Exception("Hạn dùng không được trước ngày sản xuất!");
      }

      if (!event.request.isCoaAvailable && event.request.toteCode.toUpperCase() != "VANG") {
        throw Exception("Hàng thiếu COA - Bắt buộc phải vào rổ VÀNG!");
      }

      await _repository.submitInboundItem(event.request);
      _audioService.playSuccess();
      _hapticService.vibrateSuccess();
      emit(const InboundSuccess("Đã lưu thông tin lô thành công"));
    } catch (e) {
      _audioService.playError();
      _hapticService.vibrateError();
      emit(InboundFailure(e.toString()));
    }
  }

  Future<void> _onFinishReceipt(FinishReceiptRequested event, Emitter<InboundState> emit) async {
    emit(InboundLoading());
    try {
      await _repository.finishReceipt(event.receiptId);
      _audioService.playSuccess();
      _hapticService.vibrateSuccess();
      emit(const InboundSuccess("Phiếu nhập đã hoàn tất"));
    } catch (e) {
      _audioService.playError();
      _hapticService.vibrateError();
      emit(InboundFailure(e.toString()));
    }
  }
}
