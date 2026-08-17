import '../../domain/entities/insulin_reading.dart';

sealed class InsulinState {
  const InsulinState();
}

class InsulinInitial extends InsulinState {
  const InsulinInitial();
}

class InsulinLoading extends InsulinState {
  const InsulinLoading();
}

class InsulinLoaded extends InsulinState {
  final List<InsulinReading> readings;
  const InsulinLoaded(this.readings);
}

class InsulinActionSuccess extends InsulinState {
  const InsulinActionSuccess();
}

class InsulinError extends InsulinState {
  final String message;
  const InsulinError(this.message);
}
