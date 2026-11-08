import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:hive/hive.dart';

/// In-memory stand-in for the platform keychain.
class _MemorySecureStorage implements FlutterSecureStorage {
  final Map<String, String> values = {};

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    values.remove(key);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late Directory hiveDir;
  late _MemorySecureStorage secureStorage;
  late Map<String, Box> boxes;
  late AuthLocalDataSourceImpl dataSource;

  setUp(() async {
    hiveDir = Directory.systemTemp.createTempSync('auth_local_test');
    Hive.init(hiveDir.path);
    secureStorage = _MemorySecureStorage()..values['CACHED_USER'] = '{}';
    boxes = {
      for (final name in [
        'medications',
        'doseHistory',
        'user',
        'insulinReadings',
        'labTests',
        'intakeTasks',
      ])
        name: await Hive.openBox(name),
    };
    for (final box in boxes.values) {
      await box.put('record', 'value');
    }
    dataSource = AuthLocalDataSourceImpl(
      secureStorage: secureStorage,
      medicationsBox: boxes['medications']!,
      doseHistoryBox: boxes['doseHistory']!,
      userBox: boxes['user']!,
      insulinReadingsBox: boxes['insulinReadings']!,
      labTestsBox: boxes['labTests']!,
      intakeTasksBox: boxes['intakeTasks']!,
    );
  });

  tearDown(() async {
    await Hive.close();
    hiveDir.deleteSync(recursive: true);
  });

  test('clearCache removes the cached user', () async {
    await dataSource.clearCache();

    expect(secureStorage.values, isEmpty);
  });

  // Regression: logout left the previous user's intake tasks on the device.
  test('clearCache empties every health-data box, intake tasks included', () async {
    await dataSource.clearCache();

    expect(boxes.values.map((box) => box.length), everyElement(0));
  });

  // Regression: failures were swallowed, so data could silently stay behind.
  test('clearCache propagates a failure to clear a box', () async {
    await boxes['labTests']!.close();

    await expectLater(dataSource.clearCache(), throwsA(isA<HiveError>()));
  });
}
