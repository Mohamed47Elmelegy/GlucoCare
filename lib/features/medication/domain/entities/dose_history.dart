import 'package:equatable/equatable.dart';
import 'dose_status.dart';

class DoseHistory extends Equatable {
  final String id;
  final String medicationId;
  final DateTime dateTime;
  final DoseStatus status;
  final String notes;

  const DoseHistory({
    required this.id,
    required this.medicationId,
    required this.dateTime,
    required this.status,
    required this.notes,
  });

  @override
  List<Object?> get props => [id, medicationId, dateTime, status, notes];
}
