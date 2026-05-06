import '../../data/models/putaway_models.dart';

enum PutawayStep { waitingForTote, waitingForLocation, waitingForItem }

class PutawayState {
  final PutawayTask? currentTask;
  final bool isLoading;
  final String? errorMessage;
  final PutawayStep currentStep;
  final String? lockedLocation;

  const PutawayState({
    this.currentTask,
    this.isLoading = false,
    this.errorMessage,
    this.currentStep = PutawayStep.waitingForTote,
    this.lockedLocation,
  });

  PutawayState copyWith({
    PutawayTask? currentTask,
    bool? isLoading,
    String? errorMessage,
    PutawayStep? currentStep,
    String? lockedLocation,
  }) {
    return PutawayState(
      currentTask: currentTask ?? this.currentTask,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentStep: currentStep ?? this.currentStep,
      lockedLocation: lockedLocation ?? this.lockedLocation,
    );
  }
}
