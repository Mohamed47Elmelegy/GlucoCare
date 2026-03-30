import 'package:hive/hive.dart';
import '../models/lab_test_model.dart';

abstract class LabTestLocalDataSource {
  Future<List<LabTestModel>> getLabTests();
  Future<void> addLabTest(LabTestModel labTest);
  Future<void> deleteLabTest(String id);
  Future<void> saveAllTests(List<LabTestModel> tests);
}

class LabTestLocalDataSourceImpl implements LabTestLocalDataSource {
  final Box<LabTestModel> box;

  LabTestLocalDataSourceImpl({required this.box});

  @override
  Future<List<LabTestModel>> getLabTests() async {
    return box.values.toList();
  }

  @override
  Future<void> addLabTest(LabTestModel labTest) async {
    await box.put(labTest.id, labTest);
  }

  @override
  Future<void> deleteLabTest(String id) async {
    await box.delete(id);
  }

  @override
  Future<void> saveAllTests(List<LabTestModel> tests) async {
    final Map<String, LabTestModel> map = {for (var t in tests) t.id: t};
    await box.putAll(map);
  }
}
