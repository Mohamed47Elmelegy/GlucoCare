import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/premium_app_bar.dart';
import '../../../../injection_container.dart' as di;
import '../../../../core/services/notification_service.dart';
import '../widgets/intake_todo_listener.dart';
import '../widgets/intake_todo_view.dart';

class IntakeTodoPage extends StatelessWidget {
  const IntakeTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntakeTodoListener(
      child: Scaffold(
        appBar: PremiumAppBar(
          title: AppStrings.dailyMedicationTodo,
          actions: [
            IconButton(
              icon: const Icon(Icons.notification_add_outlined),
              onPressed: () {
                di.sl<NotificationService>().showInstantNotification(
                  title: 'Test Notification',
                  body: 'If you see this, notifications are working! 🚀',
                );
              },
              tooltip: 'Test Notifications',
            ),
          ],
        ),
        body: const IntakeTodoView(),
      ),
    );
  }
}
