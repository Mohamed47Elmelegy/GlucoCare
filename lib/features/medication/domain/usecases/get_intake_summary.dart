import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/intake_status.dart';
import '../failures/intake_failure.dart';
import '../repositories/intake_repository.dart';

class GetIntakeSummaryUseCase implements UseCase<Either<IntakeFailure, IntakeSummary>, NoParams> {
  final IntakeRepository repository;

  GetIntakeSummaryUseCase(this.repository);

  @override
  Future<Either<IntakeFailure, IntakeSummary>> call(NoParams params) async {
    final result = await repository.getTasksForDate(DateTime.now());
    return result.map((tasks) {
      final total = tasks.length;
      final taken = tasks.where((t) => t.status == IntakeStatus.taken).length;
      final skipped = tasks.where((t) => t.status == IntakeStatus.skipped).length;
      final snoozed = tasks.where((t) => t.status == IntakeStatus.snoozed).length;

      return IntakeSummary(
        total: total,
        taken: taken,
        skipped: skipped,
        snoozed: snoozed,
      );
    });
  }
}

class IntakeSummary extends Equatable {
  final int total;
  final int taken;
  final int skipped;
  final int snoozed;

  const IntakeSummary({
    required this.total,
    required this.taken,
    required this.skipped,
    required this.snoozed,
  });

  double get progress => total == 0 ? 0 : taken / total;

  int get remaining => total - taken - skipped;

  @override
  List<Object?> get props => [total, taken, skipped, snoozed];
}
