import 'package:equatable/equatable.dart';
import '../../domain/entities/intake_status.dart';

abstract class IntakeEvent extends Equatable {
  const IntakeEvent();

  @override
  List<Object?> get props => [];
}

class IntakeTasksLoadRequested extends IntakeEvent {
  final DateTime date;
  const IntakeTasksLoadRequested({required this.date});

  @override
  List<Object?> get props => [date];
}

class IntakeTaskStatusChanged extends IntakeEvent {
  final String taskId;
  final IntakeStatus status;
  final DateTime? takenAt;
  final DateTime? snoozeUntil;

  const IntakeTaskStatusChanged({
    required this.taskId,
    required this.status,
    this.takenAt,
    this.snoozeUntil,
  });

  @override
  List<Object?> get props => [taskId, status, takenAt, snoozeUntil];
}
