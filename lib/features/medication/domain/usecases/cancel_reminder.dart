import 'package:fpdart/fpdart.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/services/notification_service.dart';

class CancelReminderUseCase implements UseCase<Unit, String> {
  final NotificationService notificationService;

  CancelReminderUseCase(this.notificationService);

  @override
  Future<Unit> call(String taskId) async {
    await notificationService.cancelTaskReminder(taskId);
    return unit;
  }
}
