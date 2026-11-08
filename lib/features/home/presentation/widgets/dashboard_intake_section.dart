import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../medication/domain/usecases/get_intake_summary.dart';
import '../../../medication/presentation/cubit/intake_cubit.dart';

/// Rebuilds a dashboard section from today's dose summary in [IntakeCubit].
///
/// Transient states (an action's success message, the reload that follows)
/// keep the last summary on screen instead of flashing a spinner.
class DashboardIntakeSection extends StatelessWidget {
  final Widget Function(BuildContext context, IntakeSummary summary) builder;

  /// Whether to show a spinner while loading and an error with a retry
  /// button. Secondary sections pass false and stay hidden instead.
  final bool showStatus;

  const DashboardIntakeSection({
    super.key,
    required this.builder,
    this.showStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntakeCubit, IntakeState>(
      buildWhen: (_, current) =>
          current is IntakeLoaded || current is IntakeFailure,
      builder: (context, state) => switch (state) {
        IntakeLoaded(:final summary) => builder(context, summary),
        IntakeFailure(:final message) =>
          showStatus ? _IntakeError(message: message) : const SizedBox.shrink(),
        IntakeInitial() || IntakeLoading() || IntakeActionSuccess() =>
          showStatus ? const _IntakeLoading() : const SizedBox.shrink(),
      },
    );
  }
}

class _IntakeLoading extends StatelessWidget {
  const _IntakeLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _IntakeError extends StatelessWidget {
  final String message;

  const _IntakeError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'تعذر تحميل جرعات اليوم',
          style: AppTextStyles.h3.copyWith(color: AppColors.danger, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: () =>
              context.read<IntakeCubit>().loadTasks(date: DateTime.now()),
          child: const Text('إعادة المحاولة'),
        ),
      ],
    );
  }
}
