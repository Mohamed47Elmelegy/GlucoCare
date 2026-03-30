import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/dose_history.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/medication_type.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/meal_slot.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/schedule_type.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test_ai/core/errors/failures.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/medication.dart';
import 'package:flutter_test_ai/features/medication/domain/repositories/medication_repository.dart';
import 'package:flutter_test_ai/features/medication/domain/services/reminder_service_interface.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/add_medication.dart';

class MockMedicationRepository implements MedicationRepository {
  bool shouldFail = false;
  Medication? lastAdded;

  @override
  Future<Either<Failure, void>> addMedication(Medication medication) async {
    if (shouldFail) {
      return left(const DatabaseFailure('DB Error'));
    }
    lastAdded = medication;
    return right(null);
  }

  @override
  Future<Either<Failure, void>> deleteMedication(String id) async =>
      right(null);

  @override
  Future<Either<Failure, List<Medication>>> getMedications() async => right([]);

  @override
  Future<Either<Failure, void>> updateMedication(Medication medication) async =>
      right(null);

  @override
  Future<Either<Failure, List<DoseHistory>>> getHistoryForDate(DateTime date) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> recordHistory(DoseHistory history) async {
    throw UnimplementedError();
  }

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

class MockReminderService implements ReminderServiceInterface {
  bool shouldFail = false;
  Medication? lastScheduled;
  int cancelCount = 0;
  int handleMissedCount = 0;

  @override
  Future<void> scheduleMedicationAlarms(Medication medication) async {
    if (shouldFail) {
      throw Exception('Notification Error');
    }
    lastScheduled = medication;
  }

  @override
  Future<void> cancelMedicationAlarms(String medicationId) async {
    cancelCount++;
  }

  @override
  Future<void> handleMissedDose(
    String medicationId,
    String reason,
    DateTime? rescheduleTime,
  ) async {
    handleMissedCount++;
  }

  @override
  Future<bool> requestPermissions() async => true;
}

void main() {
  late AddMedication usecase;
  late MockMedicationRepository mockRepository;
  late MockReminderService mockReminderService;

  setUp(() {
    mockRepository = MockMedicationRepository();
    mockReminderService = MockReminderService();
    usecase = AddMedication(mockRepository, mockReminderService);
  });

  final tMedication = Medication(
    id: '1',
    name: 'Metformin',
    type: MedicationType.pill,
    dosage: '500mg',
    unit: 'mg',
    mealSlots: [MealSlot.breakfast],
    customTimes: {MealSlot.breakfast: const TimeOfDay(hour: 8, minute: 0)},
    scheduleType: ScheduleType.daily,
    startDate: DateTime(2024, 1, 1),
    isActive: true,
    notes: '',
  );

  test(
    'should return right(null) and schedule alarms when successful',
    () async {
      // Act
      final result = await usecase(
        AddMedicationParams(medication: tMedication),
      );

      // Assert
      expect(result, isA<Right<Failure, void>>());
      expect(mockRepository.lastAdded, equals(tMedication));
      expect(mockReminderService.lastScheduled, equals(tMedication));
    },
  );

  test(
    'should return Left(DatabaseFailure) when repository fails and not schedule alarms',
    () async {
      // Arrange
      mockRepository.shouldFail = true;

      // Act
      final result = await usecase(
        AddMedicationParams(medication: tMedication),
      );

      // Assert
      expect(result, isA<Left<Failure, void>>());
      expect(mockReminderService.lastScheduled, isNull);
    },
  );

  test(
    'should return Left(DatabaseFailure) when alarm scheduling fails',
    () async {
      // Arrange
      mockReminderService.shouldFail = true;

      // Act
      final result = await usecase(
        AddMedicationParams(medication: tMedication),
      );

      // Assert
      expect(result, isA<Left<Failure, void>>());
      expect(
        mockRepository.lastAdded,
        equals(tMedication),
      ); // DB succeeded first
    },
  );
}
