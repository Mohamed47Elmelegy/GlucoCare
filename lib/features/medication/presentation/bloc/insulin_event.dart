import 'package:equatable/equatable.dart';
import '../../domain/entities/insulin_reading.dart';

abstract class InsulinEvent extends Equatable {
  const InsulinEvent();
  @override
  List<Object?> get props => [];
}

class LoadInsulinReadings extends InsulinEvent {
  const LoadInsulinReadings();
}

class AddInsulinReadingEvent extends InsulinEvent {
  final InsulinReading reading;
  const AddInsulinReadingEvent(this.reading);

  @override
  List<Object?> get props => [reading];
}

class SyncInsulinReadingsEvent extends InsulinEvent {
  const SyncInsulinReadingsEvent();
}
