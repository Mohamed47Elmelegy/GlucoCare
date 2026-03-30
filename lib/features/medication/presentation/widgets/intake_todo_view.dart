import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../domain/entities/meal_slot.dart';
import '../bloc/intake_bloc.dart';
import '../bloc/intake_event.dart';
import '../bloc/intake_state.dart';
import 'intake_progress_banner_widget.dart';
import 'meal_slot_section_widget.dart';

class IntakeTodoView extends StatelessWidget {
  const IntakeTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntakeBloc, IntakeState>(
      builder: (context, state) {
        if (state is IntakeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is IntakeLoaded) {
          if (state.tasks.isEmpty) {
            return _buildEmptyState(context);
          }

          final breakfastTasks = state.tasks.where((t) => t.slot == MealSlot.breakfast).toList();
          final lunchTasks = state.tasks.where((t) => t.slot == MealSlot.lunch).toList();
          final dinnerTasks = state.tasks.where((t) => t.slot == MealSlot.dinner).toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: IntakeProgressBannerWidget(summary: state.summary),
              ),
              SliverToBoxAdapter(
                child: MealSlotSectionWidget(
                  title: AppStrings.breakfast,
                  tasks: breakfastTasks,
                  onStatusChanged: (taskId, status, {takenAt, snoozeUntil}) => 
                      context.read<IntakeBloc>().add(
                        IntakeTaskStatusChanged(
                          taskId: taskId, 
                          status: status, 
                          takenAt: takenAt, 
                          snoozeUntil: snoozeUntil
                        )
                      ),
                ),
              ),
              SliverToBoxAdapter(
                child: MealSlotSectionWidget(
                  title: AppStrings.lunch,
                  tasks: lunchTasks,
                  onStatusChanged: (taskId, status, {takenAt, snoozeUntil}) => 
                      context.read<IntakeBloc>().add(
                        IntakeTaskStatusChanged(
                          taskId: taskId, 
                          status: status, 
                          takenAt: takenAt, 
                          snoozeUntil: snoozeUntil
                        )
                      ),
                ),
              ),
              SliverToBoxAdapter(
                child: MealSlotSectionWidget(
                  title: AppStrings.dinner,
                  tasks: dinnerTasks,
                  onStatusChanged: (taskId, status, {takenAt, snoozeUntil}) => 
                      context.read<IntakeBloc>().add(
                        IntakeTaskStatusChanged(
                          taskId: taskId, 
                          status: status, 
                          takenAt: takenAt, 
                          snoozeUntil: snoozeUntil
                        )
                      ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medication_outlined,
            size: 100,
            color: context.colorScheme.onSurface.withOpacity(0.1),
          ),
          const SizedBox(height: 20),
          Text(
            'No medications for today',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
