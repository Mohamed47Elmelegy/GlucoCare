import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../bloc/insulin_bloc.dart';
import '../../bloc/insulin_event.dart';
import '../../bloc/insulin_state.dart';
import 'insulin_readings_view.dart';
import '../../../domain/entities/insulin_reading.dart';

class InsulinReadingsListener extends StatelessWidget {
  const InsulinReadingsListener({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<InsulinBloc>().add(const SyncInsulinReadingsEvent());
      },
      child: BlocConsumer<InsulinBloc, InsulinState>(
        listener: (context, state) {
          if (state is InsulinActionSuccess) {
            context.read<InsulinBloc>().add(const LoadInsulinReadings());
          } else if (state is InsulinError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is InsulinLoading;
          final hasError = state is InsulinError;
          final errorMessage = state is InsulinError ? state.message : null;
          
          List<InsulinReading> readings = [];
          if (state is InsulinLoaded) {
            readings = state.readings;
          }

          return InsulinReadingsView(
            isLoading: isLoading,
            hasError: hasError,
            errorMessage: errorMessage,
            readings: readings,
            onRetry: () {
              context.read<InsulinBloc>().add(const LoadInsulinReadings());
            },
          );
        },
      ),
    );
  }
}
