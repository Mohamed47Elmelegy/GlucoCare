import 'package:fpdart/fpdart.dart';
import '../../errors/failures.dart';
import '../../services/firestore_service.dart';

abstract class BaseFirestoreRemoteDataSource<T> {
  final FirestoreService firestoreService;

  BaseFirestoreRemoteDataSource({required this.firestoreService});

  /// The Firestore collection path for this data source.
  String get collectionPath;

  /// Converts a Map to the generic type [T].
  T fromFirestore(Map<String, dynamic> json);

  /// Converts the generic type [T] to a Map for Firestore.
  Map<String, dynamic> toFirestore(T model);

  /// Saves or updates a document.
  Future<Either<Failure, Unit>> save(String docId, T model) async {
    return firestoreService.set(
      collectionPath: collectionPath,
      docId: docId,
      data: toFirestore(model),
    );
  }

  /// Gets a single document by ID.
  Future<Either<Failure, T>> getById(String docId) async {
    return firestoreService.get<T>(
      collectionPath: collectionPath,
      docId: docId,
      fromFirestore: fromFirestore,
    );
  }

  /// Gets all documents in the collection.
  Future<Either<Failure, List<T>>> getAll() async {
    return firestoreService.getAll<T>(
      collectionPath: collectionPath,
      fromFirestore: fromFirestore,
    );
  }

  /// Deletes a document by ID.
  Future<Either<Failure, Unit>> remove(String docId) async {
    return firestoreService.delete(
      collectionPath: collectionPath,
      docId: docId,
    );
  }

  /// Watches a single document by ID.
  Stream<Either<Failure, T>> watchById(String docId) {
    return firestoreService.watch<T>(
      collectionPath: collectionPath,
      docId: docId,
      fromFirestore: fromFirestore,
    );
  }

  /// Watches all documents in the collection.
  Stream<Either<Failure, List<T>>> watchAll() {
    return firestoreService.watchAll<T>(
      collectionPath: collectionPath,
      fromFirestore: fromFirestore,
    );
  }
}
