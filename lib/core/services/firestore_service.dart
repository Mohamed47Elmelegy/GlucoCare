import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  /// Sets data in a document within a collection.
  /// Auto-injects [updatedAt] timestamp.
  Future<Either<Failure, Unit>> set({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final updatedData = {...data, 'updatedAt': FieldValue.serverTimestamp()};
      await _firestore
          .collection(collectionPath)
          .doc(docId)
          .set(updatedData, SetOptions(merge: true));
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Deletes a document from a collection.
  Future<Either<Failure, Unit>> delete({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Gets a single document and converts it using [fromFirestore].
  Future<Either<Failure, T>> get<T>({
    required String collectionPath,
    required String docId,
    required T Function(Map<String, dynamic> json) fromFirestore,
  }) async {
    try {
      final doc = await _firestore.collection(collectionPath).doc(docId).get();
      if (doc.exists && doc.data() != null) {
        return Right(fromFirestore(doc.data()!));
      } else {
        return const Left(ServerFailure('Document does not exist'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Gets all documents in a collection and converts them using [fromFirestore].
  Future<Either<Failure, List<T>>> getAll<T>({
    required String collectionPath,
    required T Function(Map<String, dynamic> json) fromFirestore,
    Query Function(Query query)? queryBuilder,
  }) async {
    try {
      Query query = _firestore.collection(collectionPath);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      final snapshot = await query.get();
      final items = snapshot.docs
          .map((doc) => fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Watches a single document and emits converted [T] via Stream.
  Stream<Either<Failure, T>> watch<T>({
    required String collectionPath,
    required String docId,
    required T Function(Map<String, dynamic> json) fromFirestore,
  }) {
    return _firestore
        .collection(collectionPath)
        .doc(docId)
        .snapshots()
        .map<Either<Failure, T>>((doc) {
          if (doc.exists && doc.data() != null) {
            return Right(fromFirestore(doc.data()!));
          } else {
            return const Left(ServerFailure('Document does not exist'));
          }
        })
        .handleError((e) {
          return Left(ServerFailure(e.toString()));
        });
  }

  /// Watches a collection and emits a list of [T] via Stream.
  Stream<Either<Failure, List<T>>> watchAll<T>({
    required String collectionPath,
    required T Function(Map<String, dynamic> json) fromFirestore,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = _firestore.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query
        .snapshots()
        .map<Either<Failure, List<T>>>((snapshot) {
          final items = snapshot.docs
              .map((doc) => fromFirestore(doc.data() as Map<String, dynamic>))
              .toList();
          return Right(items);
        })
        .handleError((e) {
          return Left(ServerFailure(e.toString()));
        });
  }
}
