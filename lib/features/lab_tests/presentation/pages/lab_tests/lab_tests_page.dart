import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widgets/premium_app_bar.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../domain/entities/lab_test.dart';
import '../../bloc/lab_test_bloc.dart';
import '../../bloc/lab_test_event.dart';
import 'lab_tests_listener.dart';

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

  void _showAddLabTestDialog(BuildContext context) {
    final nameController = TextEditingController();
    final resultController = TextEditingController();
    final unitController = TextEditingController();
    final rangeController = TextEditingController();
    final categoryController = TextEditingController(text: 'Blood');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: context.l10n.labTests,
      ),
      body: const LabTestsListener(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLabTestDialog(context),
        backgroundColor: AppColors.primary,
        child: Icon(PhosphorIcons.plus(), color: AppColors.onPrimary),
      ),
    );
  }
}
