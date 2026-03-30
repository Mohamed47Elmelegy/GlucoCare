/// Base interface for creating use cases.
///
/// In Clean Architecture, each feature's logical operation is encapsulated
/// in a UseCase. Operations must return an [Either] resolving a [Failure] on Error
/// and the expected [Type] on Success.
// ignore: avoid_types_as_parameter_names
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {
  const NoParams();
}
