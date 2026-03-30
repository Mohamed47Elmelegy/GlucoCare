import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test_ai/core/storage/shared_prefs_utils.dart';
import 'package:flutter_test_ai/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_test_ai/features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import 'package:flutter_test_ai/features/auth/data/datasources/auth_firestore_remote_data_source.dart';
import 'package:flutter_test_ai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:flutter_test_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test_ai/core/services/notification_service.dart';
import 'package:flutter_test_ai/features/medication/domain/services/reminder_service_interface.dart';
import 'package:flutter_test_ai/core/storage/hive_utils.dart';
import 'package:flutter_test_ai/core/constants/hive_boxes.dart';
import 'package:flutter_test_ai/features/medication/data/datasources/medication_local_data_source.dart';
import 'package:flutter_test_ai/features/medication/data/datasources/medication_local_data_source_impl.dart';
import 'package:flutter_test_ai/features/medication/data/models/medication_model.dart';
import 'package:flutter_test_ai/features/medication/data/models/dose_history_model.dart';
import 'package:flutter_test_ai/features/medication/data/models/user_model.dart'
    as med;
import 'package:flutter_test_ai/features/medication/data/models/insulin_reading_model.dart';
import 'package:flutter_test_ai/features/lab_tests/data/models/lab_test_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test_ai/features/medication/data/datasources/medication_remote_data_source.dart';
import 'package:flutter_test_ai/features/medication/data/datasources/insulin_remote_data_source.dart';
import 'package:flutter_test_ai/features/lab_tests/data/datasources/lab_test_remote_data_source.dart';
import 'package:flutter_test_ai/core/services/firestore_service.dart';
import 'package:flutter_test_ai/features/medication/data/repositories/medication_repository_impl.dart';
import 'package:flutter_test_ai/features/medication/domain/repositories/medication_repository.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/add_medication.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/delete_medication.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_history_for_date.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_medications.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/record_medication_history.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/update_medication.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/reschedule_medication.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/sync_medications.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/medication_bloc.dart';
import 'package:flutter_test_ai/features/medication/data/models/intake_task_model.dart';
import 'package:flutter_test_ai/features/medication/data/datasources/intake_local_data_source.dart';
import 'package:flutter_test_ai/features/medication/data/datasources/intake_local_data_source_impl.dart';
import 'package:flutter_test_ai/features/medication/data/datasources/intake_remote_data_source.dart';
import 'package:flutter_test_ai/features/medication/data/repositories/intake_repository_impl.dart';
import 'package:flutter_test_ai/features/medication/domain/repositories/intake_repository.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/generate_daily_intake_tasks.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_today_intake_tasks.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/mark_intake_task.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_intake_summary.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/intake_bloc.dart';

import 'package:flutter_test_ai/features/medication/data/datasources/insulin_local_data_source.dart';
import 'package:flutter_test_ai/features/medication/data/repositories/insulin_repository_impl.dart';
import 'package:flutter_test_ai/features/medication/domain/repositories/insulin_repository.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/add_insulin_reading.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_insulin_readings.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/sync_insulin_readings.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/insulin_bloc.dart';

import 'package:flutter_test_ai/features/lab_tests/data/datasources/lab_test_local_data_source.dart';
import 'package:flutter_test_ai/features/lab_tests/data/repositories/lab_test_repository_impl.dart';
import 'package:flutter_test_ai/features/lab_tests/domain/repositories/lab_test_repository.dart';
import 'package:flutter_test_ai/features/lab_tests/domain/usecases/add_lab_test.dart';
import 'package:flutter_test_ai/features/lab_tests/domain/usecases/get_lab_tests.dart';
import 'package:flutter_test_ai/features/lab_tests/domain/usecases/sync_lab_tests.dart';
import 'package:flutter_test_ai/features/lab_tests/presentation/bloc/lab_test_bloc.dart';

import 'package:flutter_test_ai/core/theme/bloc/theme_cubit.dart';
import 'package:flutter_test_ai/core/localization/bloc/locale_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core Services
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<SharedPrefsUtils>(() => SharedPrefsUtils(sl()));
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl()));
  sl.registerLazySingleton<firebase.FirebaseAuth>(
    () => firebase.FirebaseAuth.instance,
  );
  sl.registerLazySingleton<ReminderServiceInterface>(
    () => NotificationService(),
  );
  sl.registerLazySingleton<NotificationService>(
    () => sl<ReminderServiceInterface>() as NotificationService,
  );

  // FORCE WIPE old data to solve the Hive schema mismatch TypeErrors.
  await Hive.deleteBoxFromDisk('medications');
  await Hive.deleteBoxFromDisk('medication_history');

  final medicationBox = await HiveUtils.openBoxSafely<MedicationModel>(
    HiveBoxes.medications,
  );
  final userBox = await HiveUtils.openBoxSafely<med.UserModel>(HiveBoxes.users);
  final doseHistoryBox = await HiveUtils.openBoxSafely<DoseHistoryModel>(
    HiveBoxes.doseHistory,
  );
  final insulinBox = await HiveUtils.openBoxSafely<InsulinReadingModel>(
    HiveBoxes.insulinReadings,
  );
  final labTestBox = await HiveUtils.openBoxSafely<LabTestModel>(
    HiveBoxes.labTests,
  );
  final intakeBox = await HiveUtils.openBoxSafely<IntakeTaskModel>(
    HiveBoxes.intakeTasks,
  );

  sl.registerLazySingleton<Box<MedicationModel>>(() => medicationBox);
  sl.registerLazySingleton<Box<med.UserModel>>(() => userBox);
  sl.registerLazySingleton<Box<DoseHistoryModel>>(() => doseHistoryBox);
  sl.registerLazySingleton<Box<InsulinReadingModel>>(() => insulinBox);
  sl.registerLazySingleton<Box<LabTestModel>>(() => labTestBox);
  sl.registerLazySingleton<Box<IntakeTaskModel>>(() => intakeBox);

  // Data sources
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirestoreService>(() => FirestoreService(sl()));

  sl.registerLazySingleton<AuthFirestoreRemoteDataSource>(
    () => AuthFirestoreRemoteDataSourceImpl(firestoreService: sl()),
  );
  sl.registerLazySingleton<FirebaseAuthRemoteDataSource>(
    () => FirebaseAuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: sl(),
      medicationsBox: sl<Box<MedicationModel>>(),
      doseHistoryBox: sl<Box<DoseHistoryModel>>(),
      userBox: sl<Box<med.UserModel>>(),
      insulinReadingsBox: sl<Box<InsulinReadingModel>>(),
      labTestsBox: sl<Box<LabTestModel>>(),
    ),
  );
  sl.registerLazySingleton<MedicationRemoteDataSource>(
    () => MedicationRemoteDataSourceImpl(firestoreService: sl()),
  );
  sl.registerLazySingleton<MedicationLocalDataSource>(
    () => MedicationLocalDataSourceImpl(
      medicationBox: sl(),
      doseHistoryBox: sl(),
    ),
  );
  sl.registerLazySingleton<InsulinRemoteDataSource>(
    () => InsulinRemoteDataSourceImpl(firestoreService: sl()),
  );
  sl.registerLazySingleton<InsulinLocalDataSource>(
    () => InsulinLocalDataSourceImpl(insulinBox: sl()),
  );
  sl.registerLazySingleton<LabTestRemoteDataSource>(
    () => LabTestRemoteDataSourceImpl(firestoreService: sl()),
  );
  sl.registerLazySingleton<LabTestLocalDataSource>(
    () => LabTestLocalDataSourceImpl(box: sl()),
  );
  sl.registerLazySingleton<IntakeRemoteDataSource>(
    () => IntakeRemoteDataSourceImpl(firestoreService: sl()),
  );
  sl.registerLazySingleton<IntakeLocalDataSource>(
    () => IntakeLocalDataSourceImpl(intakeBox: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      firestoreRemoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<MedicationRepository>(
    () => MedicationRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<InsulinRepository>(
    () => InsulinRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<LabTestRepository>(
    () => LabTestRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<IntakeRepository>(
    () => IntakeRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      medicationLocalDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));

  // Medication Use Cases
  sl.registerLazySingleton(() => GetMedications(sl()));
  sl.registerLazySingleton(() => AddMedication(sl(), sl()));
  sl.registerLazySingleton(() => UpdateMedication(sl(), sl()));
  sl.registerLazySingleton(() => DeleteMedication(sl(), sl()));
  sl.registerLazySingleton(() => RescheduleMedication(sl()));
  sl.registerLazySingleton(() => GetHistoryForDate(sl()));
  sl.registerLazySingleton(() => RecordMedicationHistory(sl()));
  sl.registerLazySingleton(() => SyncMedications(sl()));
  sl.registerLazySingleton(() => GenerateDailyIntakeTasksUseCase(sl()));
  sl.registerLazySingleton(() => GetTodayIntakeTasksUseCase(sl()));
  sl.registerLazySingleton(() => MarkIntakeTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetIntakeSummaryUseCase(sl()));

  // Insulin Use Cases
  sl.registerLazySingleton(() => GetInsulinReadings(sl()));
  sl.registerLazySingleton(() => AddInsulinReading(sl()));
  sl.registerLazySingleton(() => SyncInsulinReadings(sl()));

  // Lab Test Use Cases
  sl.registerLazySingleton(() => GetLabTests(sl()));
  sl.registerLazySingleton(() => AddLabTest(sl()));
  sl.registerLazySingleton(() => SyncLabTests(sl()));

  // Blocs
  sl.registerLazySingleton(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      resetPasswordUseCase: sl(),
      getCurrentUserUseCase: sl(),
      updateProfileUseCase: sl(),
      deleteAccountUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => MedicationBloc(
      getMedications: sl(),
      addMedication: sl(),
      updateMedication: sl(),
      deleteMedication: sl(),
      rescheduleMedication: sl(),
      getHistoryForDate: sl(),
      recordMedicationHistory: sl(),
      syncMedications: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => InsulinBloc(
      getInsulinReadings: sl(),
      addInsulinReading: sl(),
      syncInsulinReadings: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => LabTestBloc(getLabTests: sl(), addLabTest: sl(), syncLabTests: sl()),
  );
  sl.registerLazySingleton(
    () => IntakeBloc(
      generateDailyIntakeTasks: sl(),
      getTodayIntakeTasks: sl(),
      markIntakeTask: sl(),
      getIntakeSummary: sl(),
    ),
  );
}
