import 'package:equatable/equatable.dart';

abstract class OutboundState extends Equatable {
  const OutboundState();

  @override
  List<Object?> get props => [];
}

class OutboundIdle extends OutboundState {}

class OutboundLoading extends OutboundState {}

class OutboundToteLocked extends OutboundState {
  final int taskId;
  final String toteCode;

  const OutboundToteLocked({required this.taskId, required this.toteCode});

  @override
  List<Object?> get props => [taskId, toteCode];
}

class OutboundError extends OutboundState {
  final String message;

  const OutboundError(this.message);

  @override
  List<Object?> get props => [message];
}
