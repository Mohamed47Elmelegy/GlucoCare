import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/intake_status.dart';
import '../failures/intake_failure.dart';
import '../repositories/intake_repository.dart';

class MarkIntakeTaskUseCase implements UseCase<Either<IntakeFailure, Unit>, MarkIntakeTaskParams> {
  final IntakeRepository repository;

  MarkIntakeTaskUseCase(this.repository);

  @override
  Future<Either<IntakeFailure, Unit>> call(MarkIntakeTaskParams params) async {
    return await repository.updateTaskStatus(
      params.taskId,
      params.status,
      takenAt: params.takenAt,
      snoozeUntil: params.snoozeUntil,
    );
  }
}

class MarkIntakeTaskParams extends Equatable {
  final String taskId;
  final IntakeStatus status;
  final DateTime? takenAt;
  final DateTime? snoozeUntil;

  const MarkIntakeTaskParams({
    required this.taskId,
    required this.status,
    this.takenAt,
    this.snoozeUntil,
  });

  @override
  List<Object?> get props => [taskId, status, takenAt, snoozeUntil];
}
