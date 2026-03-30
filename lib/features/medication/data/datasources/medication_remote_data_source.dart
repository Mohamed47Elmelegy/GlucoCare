import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/firestore_service.dart';
import '../models/medication_model.dart';
import '../models/medication_schedule_model.dart';
import '../models/dose_history_model.dart';

abstract class MedicationRemoteDataSource {
  // Medication
  Future<Either<Failure, List<MedicationModel>>> getMedications(String uid);
  Future<Either<Failure, Unit>> saveMedication(
    String uid,
    MedicationModel medication,
  );
  Future<Either<Failure, Unit>> updateMedication(
    String uid,
    MedicationModel medication,
  );
  Future<Either<Failure, Unit>> deleteMedication(
    String uid,
    String medicationId,
  );

  // Schedules
  Future<Either<Failure, List<MedicationScheduleModel>>> getSchedules(
    String uid,
    String medicationId,
  );
  Future<Either<Failure, Unit>> saveSchedule(
    String uid,
    MedicationScheduleModel schedule,
  );

  // Dose History
  Future<Either<Failure, List<DoseHistoryModel>>> getDoseHistory(
    String uid,
    String medicationId,
  );
  Future<Either<Failure, List<DoseHistoryModel>>> getAllDoseHistory(String uid);
  Future<Either<Failure, List<DoseHistoryModel>>> getHistoryForDate(
    String uid,
    DateTime date,
  );
  Future<Either<Failure, Unit>> saveDoseHistory(
    String uid,
    DoseHistoryModel history,
  );
}

class MedicationRemoteDataSourceImpl implements MedicationRemoteDataSource {
  final FirestoreService firestoreService;

  MedicationRemoteDataSourceImpl({required this.firestoreService});

  String _medicationsPath(String uid) => 'users/$uid/medications';
  String _schedulesPath(String uid) => 'users/$uid/schedules';
  String _historyPath(String uid) => 'users/$uid/dose_history';

  // --- Mappers ---

  MedicationModel _medicationFromMap(Map<String, dynamic> map) {
    return MedicationModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      typeIndex: map['typeIndex'] ?? 0,
      dosage: map['dosage'] ?? '',
      unit: map['unit'] ?? '',
      intakeTimingIndex: map['intakeTimingIndex'] ?? 0,
      notes: map['notes'] ?? '',
      scheduleTimes:
          (map['scheduleTimes'] as List?)
              ?.map(
                (e) => TimeValueModel(
                  hour: e['hour'] ?? 0,
                  minute: e['minute'] ?? 0,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> _medicationToMap(MedicationModel model) {
    return {
      'id': model.id,
      'name': model.name,
      'typeIndex': model.typeIndex,
      'dosage': model.dosage,
      'unit': model.unit,
      'intakeTimingIndex': model.intakeTimingIndex,
      'notes': model.notes,
      'scheduleTimes': model.scheduleTimes
          .map((e) => {'hour': e.hour, 'minute': e.minute})
          .toList(),
    };
  }

  MedicationScheduleModel _scheduleFromMap(Map<String, dynamic> map) {
    return MedicationScheduleModel(
      id: map['id'] ?? '',
      medicationId: map['medicationId'] ?? '',
      times:
          (map['times'] as List?)
              ?.map(
                (e) => TimeValueModel(
                  hour: e['hour'] ?? 0,
                  minute: e['minute'] ?? 0,
                ),
              )
              .toList() ??
          [],
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      reminderEnabled: map['reminderEnabled'] ?? true,
    );
  }

  Map<String, dynamic> _scheduleToMap(MedicationScheduleModel model) {
    return {
      'id': model.id,
      'medicationId': model.medicationId,
      'times': model.times
          .map((e) => {'hour': e.hour, 'minute': e.minute})
          .toList(),
      'startDate': model.startDate.toIso8601String(),
      'endDate': model.endDate?.toIso8601String(),
      'reminderEnabled': model.reminderEnabled,
    };
  }

  DoseHistoryModel _historyFromMap(Map<String, dynamic> map) {
    return DoseHistoryModel(
      id: map['id'] ?? '',
      medicationId: map['medicationId'] ?? '',
      dateTime: DateTime.parse(map['dateTime']),
      statusIndex: map['statusIndex'] ?? 0,
      notes: map['notes'] ?? '',
    );
  }

  Map<String, dynamic> _historyToMap(DoseHistoryModel model) {
    return {
      'id': model.id,
      'medicationId': model.medicationId,
      'dateTime': model.dateTime.toIso8601String(),
      'statusIndex': model.statusIndex,
      'notes': model.notes,
    };
  }

  // --- Implementation ---

  @override
  Future<Either<Failure, List<MedicationModel>>> getMedications(String uid) {
    return firestoreService.getAll<MedicationModel>(
      collectionPath: _medicationsPath(uid),
      fromFirestore: _medicationFromMap,
    );
  }

  @override
  Future<Either<Failure, Unit>> saveMedication(
    String uid,
    MedicationModel medication,
  ) {
    return firestoreService.set(
      collectionPath: _medicationsPath(uid),
      docId: medication.id,
      data: _medicationToMap(medication),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateMedication(
    String uid,
    MedicationModel medication,
  ) {
    return saveMedication(uid, medication);
  }

  @override
  Future<Either<Failure, Unit>> deleteMedication(
    String uid,
    String medicationId,
  ) {
    return firestoreService.delete(
      collectionPath: _medicationsPath(uid),
      docId: medicationId,
    );
  }

  @override
  Future<Either<Failure, List<MedicationScheduleModel>>> getSchedules(
    String uid,
    String medicationId,
  ) {
    return firestoreService.getAll<MedicationScheduleModel>(
      collectionPath: _schedulesPath(uid),
      fromFirestore: _scheduleFromMap,
      queryBuilder: (query) =>
          query.where('medicationId', isEqualTo: medicationId),
    );
  }

  @override
  Future<Either<Failure, Unit>> saveSchedule(
    String uid,
    MedicationScheduleModel schedule,
  ) {
    return firestoreService.set(
      collectionPath: _schedulesPath(uid),
      docId: schedule.id,
      data: _scheduleToMap(schedule),
    );
  }

  @override
  Future<Either<Failure, List<DoseHistoryModel>>> getDoseHistory(
    String uid,
    String medicationId,
  ) {
    return firestoreService.getAll<DoseHistoryModel>(
      collectionPath: _historyPath(uid),
      fromFirestore: _historyFromMap,
      queryBuilder: (query) =>
          query.where('medicationId', isEqualTo: medicationId),
    );
  }

  @override
  Future<Either<Failure, List<DoseHistoryModel>>> getAllDoseHistory(
    String uid,
  ) {
    return firestoreService.getAll<DoseHistoryModel>(
      collectionPath: _historyPath(uid),
      fromFirestore: _historyFromMap,
    );
  }

  @override
  Future<Either<Failure, List<DoseHistoryModel>>> getHistoryForDate(
    String uid,
    DateTime date,
  ) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return firestoreService.getAll<DoseHistoryModel>(
      collectionPath: _historyPath(uid),
      fromFirestore: _historyFromMap,
      queryBuilder: (query) => query
          .where(
            'dateTime',
            isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
          )
          .where('dateTime', isLessThan: endOfDay.toIso8601String()),
    );
  }

  @override
  Future<Either<Failure, Unit>> saveDoseHistory(
    String uid,
    DoseHistoryModel history,
  ) {
    return firestoreService.set(
      collectionPath: _historyPath(uid),
      docId: history.id,
      data: _historyToMap(history),
    );
  }
}
