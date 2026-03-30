import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/premium_app_bar.dart';
import '../../domain/entities/lab_test.dart';
import '../bloc/lab_test_bloc.dart';
import '../bloc/lab_test_event.dart';
import '../bloc/lab_test_state.dart';
import '../../../../core/widgets/premium_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class LabTestsPage extends StatefulWidget {
  const LabTestsPage({super.key});

  @override
  State<LabTestsPage> createState() => _LabTestsPageState();
}

class _LabTestsPageState extends State<LabTestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<LabTestBloc>().add(GetLabTestsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: context.l10n.labTests,
      ),
      body: RefreshIndicator(
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
            if (state is LabTestLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LabTestLoaded) {
              if (state.labTests.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildLabTestsList(state.labTests, context);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLabTestDialog(context),
        backgroundColor: AppColors.primary,
        child: Icon(PhosphorIcons.plus(), color: AppColors.onPrimary),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PremiumCard(
            glassmorphic: true,
            child: Icon(
              PhosphorIcons.flask(PhosphorIconsStyle.light),
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.noLabTests,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.tapToRecordTest,
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabTestsList(List<LabTest> tests, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tests.length,
      itemBuilder: (context, index) {
        final test = tests[index];
        return _buildLabTestCard(test, context);
      },
    );
  }

  Widget _buildLabTestCard(LabTest test, BuildContext context) {
    return PremiumCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  test.testName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.premiumMint.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.premiumMint.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  test.category,
                  style: const TextStyle(
                    color: AppColors.premiumMint,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                test.result,
                style: const TextStyle(
                  color: AppColors.premiumMint,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  test.unit,
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Ref: ${test.referenceRange}',
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(test.date),
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (test.notes != null && test.notes!.isNotEmpty) ...[
            Divider(
              height: 32,
              color: context.colorScheme.outline.withValues(alpha: 0.1),
            ),
            Text(
              test.notes!,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddLabTestDialog(BuildContext context) {
    final nameController = TextEditingController();
    final resultController = TextEditingController();
    final unitController = TextEditingController();
    final rangeController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          context.l10n.addLabTest,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: nameController,
                label: context.l10n.testName,
                icon: PhosphorIcons.flask(PhosphorIconsStyle.bold),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: resultController,
                label: context.l10n.result,
                icon: PhosphorIcons.pulse(PhosphorIconsStyle.bold),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: unitController,
                label: context.l10n.unit,
                icon: PhosphorIcons.hash(PhosphorIconsStyle.bold),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: rangeController,
                label: context.l10n.referenceRange,
                icon: PhosphorIcons.info(PhosphorIconsStyle.bold),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: categoryController,
                label: context.l10n.category,
                icon: PhosphorIcons.squaresFour(PhosphorIconsStyle.bold),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.l10n.cancel,
              style: TextStyle(color: context.colorScheme.outline),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: AppButton(
              text: context.l10n.add,
              onPressed: () {
                final test = LabTest(
                  id: const Uuid().v4(),
                  testName: nameController.text,
                  result: resultController.text,
                  unit: unitController.text,
                  referenceRange: rangeController.text,
                  date: DateTime.now(),
                  category: categoryController.text,
                );
                context.read<LabTestBloc>().add(AddLabTestEvent(labTest: test));
                Navigator.pop(dialogContext);
              },
            ),
          ),
        ],
      ),
    );
  }
}
