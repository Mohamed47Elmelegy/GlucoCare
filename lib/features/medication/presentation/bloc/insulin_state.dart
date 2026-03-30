import 'package:equatable/equatable.dart';
import '../../domain/entities/insulin_reading.dart';

abstract class InsulinState extends Equatable {
  const InsulinState();
  @override
  List<Object?> get props => [];
}

class InsulinInitial extends InsulinState {}

class InsulinLoading extends InsulinState {}

class InsulinLoaded extends InsulinState {
  final List<InsulinReading> readings;
  const InsulinLoaded(this.readings);

  @override
  List<Object?> get props => [readings];
}

class InsulinError extends InsulinState {
  final String message;
  const InsulinError(this.message);

  @override
  List<Object?> get props => [message];
}

class InsulinActionSuccess extends InsulinState {
  const InsulinActionSuccess();
}
