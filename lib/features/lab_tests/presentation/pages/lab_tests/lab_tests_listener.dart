import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../bloc/lab_test_bloc.dart';
import '../../bloc/lab_test_event.dart';
import '../../bloc/lab_test_state.dart';
import 'lab_tests_view.dart';
import '../../../domain/entities/lab_test.dart';

class LabTestsListener extends StatelessWidget {
  const LabTestsListener({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<LabTestBloc>().add(const SyncLabTestsEvent());
      },
      child: BlocConsumer<LabTestBloc, LabTestState>(
        listener: (context, state) {
          if (state is LabTestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is LabTestActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LabTestLoading;
          
          List<LabTest> labTests = [];
          if (state is LabTestLoaded) {
            labTests = state.labTests;
          }

          return LabTestsView(
            isLoading: isLoading,
            labTests: labTests,
          );
        },
      ),
    );
  }
}
