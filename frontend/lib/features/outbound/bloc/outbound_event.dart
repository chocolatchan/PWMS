import 'package:equatable/equatable.dart';

abstract class OutboundEvent extends Equatable {
  const OutboundEvent();

  @override
  List<Object?> get props => [];
}

class StartTaskRequested extends OutboundEvent {
  final int taskId;
  final String toteCode;

  const StartTaskRequested({required this.taskId, required this.toteCode});

  @override
  List<Object?> get props => [taskId, toteCode];
}
