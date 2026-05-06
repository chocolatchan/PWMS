import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/hardware/audio_service.dart';
import '../../../core/hardware/haptic_service.dart';
import '../data/outbound_repository.dart';
import 'outbound_event.dart';
import 'outbound_state.dart';

class OutboundBloc extends Bloc<OutboundEvent, OutboundState> {
  final OutboundRepository _repository;
  final AudioService _audioService;
  final HapticService _hapticService;

  OutboundBloc(
    this._repository,
    this._audioService,
    this._hapticService,
  ) : super(OutboundIdle()) {
    on<StartTaskRequested>(_onStartTaskRequested);
  }

  Future<void> _onStartTaskRequested(
    StartTaskRequested event,
    Emitter<OutboundState> emit,
  ) async {
    emit(OutboundLoading());
    try {
      await _repository.startPicking(event.taskId, event.toteCode);
      _audioService.playSuccess();
      _hapticService.vibrateSuccess();
      emit(OutboundToteLocked(taskId: event.taskId, toteCode: event.toteCode));
    } catch (e) {
      _audioService.playError();
      _hapticService.vibrateError();
      emit(OutboundError(e.toString()));
    }
  }
}
