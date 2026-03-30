import 'package:hive/hive.dart';
import '../../domain/entities/dose_history.dart';
import '../../domain/entities/dose_status.dart';

part 'dose_history_model.g.dart';

@HiveType(typeId: 23)
class DoseHistoryModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String medicationId;
  @HiveField(2)
  final DateTime dateTime;
  @HiveField(3)
  final int statusIndex;
  @HiveField(4)
  final String notes;

  DoseHistoryModel({
    required this.id,
    required this.medicationId,
    required this.dateTime,
    required this.statusIndex,
    required this.notes,
  });

  factory DoseHistoryModel.fromEntity(DoseHistory history) {
    return DoseHistoryModel(
      id: history.id,
      medicationId: history.medicationId,
      dateTime: history.dateTime,
      statusIndex: history.status.index,
      notes: history.notes,
    );
  }

  DoseHistory toEntity() {
    return DoseHistory(
      id: id,
      medicationId: medicationId,
      dateTime: dateTime,
      status: DoseStatus.values[statusIndex],
      notes: notes,
    );
  }
}
