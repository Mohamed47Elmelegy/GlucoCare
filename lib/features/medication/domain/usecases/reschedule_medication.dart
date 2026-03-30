import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../services/reminder_service_interface.dart';

class RescheduleMedication
    implements UseCase<Either<Failure, void>, RescheduleMedicationParams> {
  final ReminderServiceInterface reminderService;

  RescheduleMedication(this.reminderService);

  @override
  Future<Either<Failure, void>> call(RescheduleMedicationParams params) async {
    try {
      await reminderService.handleMissedDose(
        params.medicationId,
        params.reason,
        params.rescheduleTime,
      );
      return right(null);
    } catch (e) {
      return left(DatabaseFailure('Failed to reschedule medication: $e'));
    }
  }
}

class RescheduleMedicationParams {
  final String medicationId;
  final String reason;
  final DateTime? rescheduleTime;

  RescheduleMedicationParams({
    required this.medicationId,
    required this.reason,
    this.rescheduleTime,
  });
}
