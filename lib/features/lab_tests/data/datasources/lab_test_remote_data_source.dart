import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/firestore_service.dart';
import '../models/lab_test_model.dart';

abstract class LabTestRemoteDataSource {
  Future<Either<Failure, List<LabTestModel>>> getLabTests(String uid);
  Future<Either<Failure, Unit>> addLabTest(String uid, LabTestModel labTest);
  Future<Either<Failure, Unit>> deleteLabTest(String uid, String id);
}

class LabTestRemoteDataSourceImpl implements LabTestRemoteDataSource {
  final FirestoreService firestoreService;

  LabTestRemoteDataSourceImpl({required this.firestoreService});

  String _collectionPath(String uid) => 'users/$uid/lab_tests';

  LabTestModel _fromMap(Map<String, dynamic> map) {
    return LabTestModel(
      id: map['id'] ?? '',
      testName: map['testName'] ?? '',
      result: map['result'] ?? '',
      unit: map['unit'] ?? '',
      referenceRange: map['referenceRange'] ?? '',
      date: DateTime.parse(map['date']),
      notes: map['notes'],
      category: map['category'] ?? '',
    );
  }

  Map<String, dynamic> _toMap(LabTestModel model) {
    return {
      'id': model.id,
      'testName': model.testName,
      'result': model.result,
      'unit': model.unit,
      'referenceRange': model.referenceRange,
      'date': model.date.toIso8601String(),
      'notes': model.notes,
      'category': model.category,
    };
  }

  @override
  Future<Either<Failure, List<LabTestModel>>> getLabTests(String uid) async {
    return firestoreService.getAll<LabTestModel>(
      collectionPath: _collectionPath(uid),
      fromFirestore: _fromMap,
      queryBuilder: (query) => query.orderBy('date', descending: true),
    );
  }

  @override
  Future<Either<Failure, Unit>> addLabTest(
    String uid,
    LabTestModel labTest,
  ) async {
    return firestoreService.set(
      collectionPath: _collectionPath(uid),
      docId: labTest.id,
      data: _toMap(labTest),
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteLabTest(String uid, String id) async {
    return firestoreService.delete(
      collectionPath: _collectionPath(uid),
      docId: id,
    );
  }
}
