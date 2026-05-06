// ============================================================
// FILE: putaway_models.dart
// Pure domain state — no code generation required.
// ============================================================

import 'putaway_mock_data.dart';

enum PutawayStep { scanTote, loading, confirm, success }

class PutawayTaskState {
  final PutawayStep step;
  final PutawayTote? tote;
  final bool isLocationFull;    // user pressed "Báo Kệ Đầy"
  final String scannedLocation; // what user typed/scanned
  final String pin;             // TOX guard PIN
  final bool isSubmitting;
  final String? errorMessage;

  const PutawayTaskState({
    this.step = PutawayStep.scanTote,
    this.tote,
    this.isLocationFull = false,
    this.scannedLocation = '',
    this.pin = '',
    this.isSubmitting = false,
    this.errorMessage,
  });

  // ── Derived ──────────────────────────────────────────────

  String get activeLocation =>
      isLocationFull ? (tote?.alternateLocation ?? '') : (tote?.suggestedLocation ?? '');

  bool get isLocationMatch =>
      scannedLocation.isNotEmpty &&
      scannedLocation.trim().toUpperCase() == activeLocation.toUpperCase();

  bool get isPinValid => !isToxic || pin == '1234';

  bool get isToxic => tote?.isToxic ?? false;

  bool get canConfirm =>
      tote != null &&
      isLocationMatch &&
      isPinValid &&
      !isSubmitting;

  PutawayTaskState copyWith({
    PutawayStep? step,
    PutawayTote? tote,
    bool? isLocationFull,
    String? scannedLocation,
    String? pin,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PutawayTaskState(
      step: step ?? this.step,
      tote: tote ?? this.tote,
      isLocationFull: isLocationFull ?? this.isLocationFull,
      scannedLocation: scannedLocation ?? this.scannedLocation,
      pin: pin ?? this.pin,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
