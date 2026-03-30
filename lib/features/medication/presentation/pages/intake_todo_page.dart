import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/premium_app_bar.dart';
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
        ),
        body: const IntakeTodoView(),
      ),
    );
  }
}
