import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widgets/premium_app_bar.dart';
import '../../../domain/entities/insulin_reading.dart';
import '../../bloc/insulin_bloc.dart';
import '../../bloc/insulin_event.dart';
import '../../utils/insulin_reading_ui_extensions.dart';
import 'insulin_readings_listener.dart';

class InsulinReadingsPage extends StatefulWidget {
  const InsulinReadingsPage({super.key});

  @override
  State<InsulinReadingsPage> createState() => _InsulinReadingsPageState();
}

class _InsulinReadingsPageState extends State<InsulinReadingsPage> {
  final _readingController = TextEditingController();
  final _noteController = TextEditingController();
  ReadingType _selectedReadingType = ReadingType.fasting;

  List<ReadingType> get _readingTypes => ReadingType.values;

  @override
  void initState() {
    super.initState();
    context.read<InsulinBloc>().add(const LoadInsulinReadings());
    _selectedReadingType = ReadingType.fasting;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _readingController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addReading() {
    final value = double.tryParse(_readingController.text);
    if (value == null) return;

    final reading = InsulinReading(
      id: const Uuid().v4(),
      value: value,
      readingType: _selectedReadingType,
      timestamp: DateTime.now(),
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );

    context.read<InsulinBloc>().add(AddInsulinReadingEvent(reading));
    Navigator.pop(context);
    _readingController.clear();
    _noteController.clear();
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  context.l10n.bloodSugarReading,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<ReadingType>(
                  value: _selectedReadingType,
                  decoration: InputDecoration(
                    labelText: context.l10n.readingType,
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  items: _readingTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.label(context)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setModalState(() {
                        _selectedReadingType = value;
                      });
                      setState(() {
                        _selectedReadingType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _readingController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.readingValue,
                    prefixIcon: const Icon(Icons.show_chart),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: context.l10n.notes,
                    prefixIcon: const Icon(Icons.notes),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _addReading,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      context.l10n.saveReading,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: context.l10n.bloodSugarReadings,
      ),
      body: const InsulinReadingsListener(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: _showAddDialog,
          icon: const Icon(Icons.add),
          label: Text(
            context.l10n.add,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
