import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/firestore_service.dart';
import '../models/medication_model.dart';
import '../models/dose_history_model.dart';

abstract class MedicationRemoteDataSource {
  Future<Either<Failure, List<MedicationModel>>> getMedications(String uid);
  Future<Either<Failure, Unit>> saveMedication(String uid, MedicationModel medication);
  Future<Either<Failure, Unit>> updateMedication(String uid, MedicationModel medication);
  Future<Either<Failure, Unit>> deleteMedication(String uid, String medicationId);
  Future<Either<Failure, List<DoseHistoryModel>>> getAllDoseHistory(String uid);
  Future<Either<Failure, Unit>> saveDoseHistory(String uid, DoseHistoryModel history);
}

class MedicationRemoteDataSourceImpl implements MedicationRemoteDataSource {
  final FirestoreService firestoreService;

  MedicationRemoteDataSourceImpl({required this.firestoreService});

  String _medicationsPath(String uid) => 'users/$uid/medications';
  String _historyPath(String uid) => 'users/$uid/dose_history';

  @override
  Future<Either<Failure, List<MedicationModel>>> getMedications(String uid) {
    return firestoreService.getAll<MedicationModel>(
      collectionPath: _medicationsPath(uid),
      fromFirestore: MedicationModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, Unit>> saveMedication(String uid, MedicationModel medication) {
    return firestoreService.set(
      collectionPath: _medicationsPath(uid),
      docId: medication.id,
      data: medication.toJson(),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateMedication(String uid, MedicationModel medication) {
    return saveMedication(uid, medication);
  }

  @override
  Future<Either<Failure, Unit>> deleteMedication(String uid, String medicationId) {
    return firestoreService.delete(
      collectionPath: _medicationsPath(uid),
      docId: medicationId,
    );
  }

  @override
  Future<Either<Failure, List<DoseHistoryModel>>> getAllDoseHistory(String uid) {
    return firestoreService.getAll<DoseHistoryModel>(
      collectionPath: _historyPath(uid),
      fromFirestore: (map) => DoseHistoryModel.fromJson(map),
    );
  }

  @override
  Future<Either<Failure, Unit>> saveDoseHistory(String uid, DoseHistoryModel history) {
    return firestoreService.set(
      collectionPath: _historyPath(uid),
      docId: history.id,
      data: history.toJson(),
    );
  }
}
