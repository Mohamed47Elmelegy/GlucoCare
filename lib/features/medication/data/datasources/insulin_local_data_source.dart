import 'package:hive_flutter/hive_flutter.dart';
import '../models/insulin_reading_model.dart';

abstract class InsulinLocalDataSource {
  Future<List<InsulinReadingModel>> getReadings();
  Future<void> addReading(InsulinReadingModel reading);
  Future<void> saveAllReadings(List<InsulinReadingModel> readings);
}

class InsulinLocalDataSourceImpl implements InsulinLocalDataSource {
  final Box<InsulinReadingModel> insulinBox;

  InsulinLocalDataSourceImpl({required this.insulinBox});

  @override
  Future<List<InsulinReadingModel>> getReadings() async {
    return insulinBox.values.toList().reversed.toList();
  }

  @override
  Future<void> addReading(InsulinReadingModel reading) async {
    await insulinBox.put(reading.id, reading);
  }

  @override
  Future<void> saveAllReadings(List<InsulinReadingModel> readings) async {
    final Map<String, InsulinReadingModel> map = {
      for (var r in readings) r.id: r,
    };
    await insulinBox.putAll(map);
  }
}
