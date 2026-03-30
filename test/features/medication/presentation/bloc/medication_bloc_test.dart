import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test_ai/core/errors/failures.dart';
import 'package:flutter_test_ai/core/usecases/usecase.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/medication.dart';
import 'package:flutter_test_ai/features/medication/domain/repositories/medication_repository.dart';
import 'package:flutter_test_ai/features/medication/domain/services/reminder_service_interface.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/add_medication.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/delete_medication.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_medications.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/reschedule_medication.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/update_medication.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_history_for_date.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/record_medication_history.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/dose_history.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/medication_type.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/meal_slot.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/schedule_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/sync_medications.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/medication_bloc.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/medication_event.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/medication_state.dart';

// Dummies for DI
class DummyMedicationRepository implements MedicationRepository {
  @override
  Future<Either<Failure, void>> addMedication(Medication medication) async =>
      right(null);
  @override
  Future<Either<Failure, void>> deleteMedication(String id) async =>
      right(null);
  @override
  Future<Either<Failure, List<DoseHistory>>> getHistoryForDate(
    DateTime date,
  ) async => right([]);
  @override
  Future<Either<Failure, List<Medication>>> getMedications() async => right([]);
  @override
  Future<Either<Failure, void>> recordHistory(DoseHistory history) async =>
      right(null);
  @override
  Future<Either<Failure, void>> updateMedication(Medication medication) async =>
      right(null);
  @override
  Future<Either<Failure, void>> syncMedications() async => right(null);

  @override
  Future<Either<Failure, void>> completeMedicationCourse(String id) async =>
      right(null);

  @override
  Future<Either<Failure, List<Medication>>> getTodayMedications(
    DateTime date,
  ) async => right([]);
}

class DummyReminderService implements ReminderServiceInterface {
  @override
  Future<void> cancelMedicationAlarms(String medicationId) async {}
  @override
  Future<void> handleMissedDose(
    String medicationId,
    String reason,
    DateTime? rescheduleTime,
  ) async {}
  @override
  Future<void> scheduleMedicationAlarms(Medication medication) async {}
  @override
  Future<bool> requestPermissions() async => true;
}

// Mocks for Use Cases
class MockGetMedications extends GetMedications {
  MockGetMedications(super.repository);
  bool shouldFail = false;
  List<Medication> returnList = [];

  @override
  Future<Either<Failure, List<Medication>>> call(NoParams params) async {
    if (shouldFail) return left(const DatabaseFailure('Error'));
    return right(returnList);
  }
}

class MockAddMedication extends AddMedication {
  MockAddMedication(super.repository, super.reminderService);
  bool shouldFail = false;

  @override
  Future<Either<Failure, void>> call(AddMedicationParams params) async {
    if (shouldFail) return left(const DatabaseFailure('Add Error'));
    return right(null);
  }
}

class MockUpdateMedication extends UpdateMedication {
  MockUpdateMedication(super.repository, super.reminderService);
  @override
  Future<Either<Failure, void>> call(UpdateMedicationParams params) async =>
      right(null);
}

class MockDeleteMedication extends DeleteMedication {
  MockDeleteMedication(super.repository, super.reminderService);
  @override
  Future<Either<Failure, void>> call(DeleteMedicationParams params) async =>
      right(null);
}

class MockRescheduleMedication extends RescheduleMedication {
  MockRescheduleMedication(super.reminderService);
  @override
  Future<Either<Failure, void>> call(RescheduleMedicationParams params) async =>
      right(null);
}

class MockGetHistoryForDate extends GetHistoryForDate {
  MockGetHistoryForDate(super.repository);
  @override
  Future<Either<Failure, List<DoseHistory>>> call(DateTime date) async =>
      right([]);
}

class MockRecordMedicationHistory extends RecordMedicationHistory {
  MockRecordMedicationHistory(super.repository);
  @override
  Future<Either<Failure, void>> call(DoseHistory history) async => right(null);
}

class MockSyncMedications extends SyncMedications {
  MockSyncMedications(super.repository);
  @override
  Future<Either<Failure, void>> call(NoParams params) async => right(null);
}

void main() {
  late MedicationBloc bloc;
  late MockGetMedications mockGetMedications;
  late MockAddMedication mockAddMedication;
  late MockUpdateMedication mockUpdateMedication;
  late MockDeleteMedication mockDeleteMedication;
  late MockRescheduleMedication mockRescheduleMedication;
  late MockGetHistoryForDate mockGetHistoryForDate;
  late MockRecordMedicationHistory mockRecordMedicationHistory;
  late MockSyncMedications mockSyncMedications;

  setUp(() {
    // Note: In a real test suite with Mockito, we wouldn't need to pass 'null' appropriately,
    // but since we override `call`, it won't execute super constructors' actual logic.
    final dummyRepo = DummyMedicationRepository();
    final dummyService = DummyReminderService();

    mockGetMedications = MockGetMedications(dummyRepo);
    mockAddMedication = MockAddMedication(dummyRepo, dummyService);
    mockUpdateMedication = MockUpdateMedication(dummyRepo, dummyService);
    mockDeleteMedication = MockDeleteMedication(dummyRepo, dummyService);
    mockRescheduleMedication = MockRescheduleMedication(dummyService);
    mockGetHistoryForDate = MockGetHistoryForDate(dummyRepo);
    mockRecordMedicationHistory = MockRecordMedicationHistory(dummyRepo);
    mockSyncMedications = MockSyncMedications(dummyRepo);

    bloc = MedicationBloc(
      getMedications: mockGetMedications,
      addMedication: mockAddMedication,
      updateMedication: mockUpdateMedication,
      deleteMedication: mockDeleteMedication,
      rescheduleMedication: mockRescheduleMedication,
      getHistoryForDate: mockGetHistoryForDate,
      recordMedicationHistory: mockRecordMedicationHistory,
      syncMedications: mockSyncMedications,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('GetMedicationsEvent', () {
    test(
      'should emit [MedicationLoading, MedicationLoaded] on success',
      () async {
        final List<Medication> tList = [];
        mockGetMedications.returnList = tList;

        final expectedStates = [
          isA<MedicationLoading>(),
          isA<MedicationLoaded>(),
        ];

        expectLater(bloc.stream, emitsInOrder(expectedStates));

        bloc.add(GetMedicationsEvent());
      },
    );

    test(
      'should emit [MedicationLoading, MedicationError] on failure',
      () async {
        mockGetMedications.shouldFail = true;

        final expectedStates = [
          isA<MedicationLoading>(),
          isA<MedicationError>(),
        ];

        expectLater(bloc.stream, emitsInOrder(expectedStates));

        bloc.add(GetMedicationsEvent());
      },
    );
  });

  group('AddMedicationEvent', () {
    final tMedication = Medication(
      id: '1',
      name: 'Test',
      type: MedicationType.pill,
      dosage: '10mg',
      unit: 'mg',
      mealSlots: [MealSlot.breakfast],
      customTimes: {MealSlot.breakfast: const TimeOfDay(hour: 8, minute: 0)},
      scheduleType: ScheduleType.daily,
      startDate: DateTime(2024, 1, 1),
      isActive: true,
      notes: '',
    );

    test(
      'should emit [Loading, Success] and call GetMedicationsEvent on success',
      () async {
        final expectedStates = [
          isA<MedicationLoading>(),
          isA<MedicationActionSuccess>(),
          isA<MedicationLoading>(), // From the GetMedicationsEvent call
          isA<MedicationLoaded>(),
        ];

        expectLater(bloc.stream, emitsInOrder(expectedStates));

        bloc.add(AddMedicationEvent(medication: tMedication));
      },
    );

    test('should emit [Loading, Error] on failure', () async {
      mockAddMedication.shouldFail = true;

      final expectedStates = [isA<MedicationLoading>(), isA<MedicationError>()];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(AddMedicationEvent(medication: tMedication));
    });
  });
}
