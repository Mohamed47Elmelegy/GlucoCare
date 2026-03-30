import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/firestore_service.dart';
import '../models/insulin_reading_model.dart';

abstract class InsulinRemoteDataSource {
  Future<Either<Failure, List<InsulinReadingModel>>> getReadings(String uid);
  Future<Either<Failure, Unit>> addReading(
    String uid,
    InsulinReadingModel reading,
  );
}

class InsulinRemoteDataSourceImpl implements InsulinRemoteDataSource {
  final FirestoreService firestoreService;

  InsulinRemoteDataSourceImpl({required this.firestoreService});

  String _collectionPath(String uid) => 'users/$uid/insulin_readings';

  InsulinReadingModel _fromMap(Map<String, dynamic> map) {
    return InsulinReadingModel(
      id: map['id'] ?? '',
      value: map['value'] ?? 0.0,
      readingType: map['readingType'] ?? 'fasting',
      timestamp: DateTime.parse(map['timestamp']),
      note: map['note'],
    );
  }

  Map<String, dynamic> _toMap(InsulinReadingModel model) {
    return {
      'id': model.id,
      'value': model.value,
      'readingType': model.readingType,
      'timestamp': model.timestamp.toIso8601String(),
      'note': model.note,
    };
  }

  @override
  Future<Either<Failure, List<InsulinReadingModel>>> getReadings(
    String uid,
  ) async {
    return firestoreService.getAll<InsulinReadingModel>(
      collectionPath: _collectionPath(uid),
      fromFirestore: _fromMap,
      queryBuilder: (query) => query.orderBy('timestamp', descending: true),
    );
  }

  @override
  Future<Either<Failure, Unit>> addReading(
    String uid,
    InsulinReadingModel reading,
  ) async {
    return firestoreService.set(
      collectionPath: _collectionPath(uid),
      docId: reading.id,
      data: _toMap(reading),
    );
  }
}
