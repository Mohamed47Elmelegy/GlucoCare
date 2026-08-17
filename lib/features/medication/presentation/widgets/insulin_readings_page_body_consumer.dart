import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/context_extension.dart';
import '../cubit/insulin_cubit.dart';
import '../cubit/insulin_state.dart';
import 'insulin_readings_page_body.dart';

class InsulinReadingsPageBodyConsumer extends StatelessWidget {
  const InsulinReadingsPageBodyConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<InsulinCubit>().syncReadings();
      },
      child: BlocConsumer<InsulinCubit, InsulinState>(
        listener: (context, state) {
          if (state is InsulinActionSuccess) {
            context.read<InsulinCubit>().loadReadings();
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
          if (state is InsulinLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is InsulinLoaded) {
            return InsulinReadingsPageBody(readings: state.readings);
          }

          if (state is InsulinError) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                alignment: Alignment.center,
                child: Text(state.message),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
