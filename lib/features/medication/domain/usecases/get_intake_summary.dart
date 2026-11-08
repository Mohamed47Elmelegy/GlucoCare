import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dose_timeline_entry.dart';
import '../entities/intake_status.dart';
import '../failures/intake_failure.dart';
import '../repositories/intake_repository.dart';

class GetIntakeSummaryUseCase implements UseCase<Either<IntakeFailure, IntakeSummary>, NoParams> {
  final IntakeRepository repository;
  final DateTime Function() _clock;

  GetIntakeSummaryUseCase(this.repository, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  @override
  Future<Either<IntakeFailure, IntakeSummary>> call(NoParams params) async {
    final now = _clock();
    final result = await repository.getTasksForDate(now);
    return result.map((tasks) {
      final total = tasks.length;
      final taken = tasks.where((t) => t.status == IntakeStatus.taken).length;
      final skipped = tasks.where((t) => t.status == IntakeStatus.skipped).length;
      final snoozed = tasks.where((t) => t.status == IntakeStatus.snoozed).length;
      final timeline = tasks
          .map((task) => DoseTimelineEntry.resolve(task, now))
          .toList()
        ..sort((a, b) => a.dueAt.compareTo(b.dueAt));

      return IntakeSummary(
        total: total,
        taken: taken,
        skipped: skipped,
        snoozed: snoozed,
        timeline: timeline,
      );
    });
  }
}

class IntakeSummary extends Equatable {
  final int total;
  final int taken;
  final int skipped;
  final int snoozed;

  /// Today's doses ordered by when they are due.
  final List<DoseTimelineEntry> timeline;

  const IntakeSummary({
    required this.total,
    required this.taken,
    required this.skipped,
    required this.snoozed,
    this.timeline = const [],
  });

  double get progress => total == 0 ? 0 : taken / total;

  int get remaining => total - taken - skipped;

  /// The earliest dose still waiting to be taken, or null when none is left.
  DoseTimelineEntry? get nextDose =>
      timeline.where((entry) => entry.isUpcoming).firstOrNull;

  /// Doses not taken within [DoseTimelineEntry.missedAfter] of their due time.
  List<DoseTimelineEntry> get missedDoses =>
      timeline.where((entry) => entry.isMissed).toList();

  @override
  List<Object?> get props => [total, taken, skipped, snoozed, timeline];
}
