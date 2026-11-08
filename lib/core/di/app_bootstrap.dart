import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/lab_tests/data/models/lab_test_model.dart';
import '../../features/medication/data/models/dose_history_model.dart';
import '../../features/medication/data/models/insulin_reading_model.dart';
import '../../features/medication/data/models/intake_task_model.dart';
import '../../features/medication/data/models/medication_model.dart';
import '../../features/medication/data/models/medication_schedule_model.dart';
import '../../firebase_options.dart';
import '../services/logger_service.dart';
import 'injection_container.dart' as di;

Future<void>? _bootstrapping;

/// Initializes Firebase, Hive (with every adapter) and the get_it graph.
///
/// Shared by `main()` and the background notification isolate, which starts
/// with nothing initialized. Safe to call more than once per isolate; a failed
/// attempt can be retried.
Future<void> bootstrapApp() {
  return _bootstrapping ??= _bootstrap().catchError((Object error, StackTrace stack) {
    _bootstrapping = null;
    Error.throwWithStackTrace(error, stack);
  });
}

Future<void> _bootstrap() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  await Hive.initFlutter();
  _registerAdapter(UserModelAdapter());
  _registerAdapter(MedicationModelAdapter());
  _registerAdapter(MedicationScheduleModelAdapter());
  _registerAdapter(DoseHistoryModelAdapter());
  _registerAdapter(TimeValueModelAdapter());
  _registerAdapter(InsulinReadingModelAdapter());
  _registerAdapter(LabTestModelAdapter());
  _registerAdapter(IntakeTaskModelAdapter());

  if (!di.sl.isRegistered<LoggerService>()) {
    await di.init();
  }
}

void _registerAdapter<T>(TypeAdapter<T> adapter) {
  if (!Hive.isAdapterRegistered(adapter.typeId)) {
    Hive.registerAdapter(adapter);
  }
}
