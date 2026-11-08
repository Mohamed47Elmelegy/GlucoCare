import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/core/services/logger_service.dart';
import 'package:flutter_test_ai/core/storage/hive_utils.dart';
import 'package:hive/hive.dart';

class _Reading {
  final int value;
  _Reading(this.value);
}

class _ReadingAdapter extends TypeAdapter<_Reading> {
  @override
  final int typeId = 200;

  @override
  _Reading read(BinaryReader reader) => _Reading(reader.readInt());

  @override
  void write(BinaryWriter writer, _Reading obj) => writer.writeInt(obj.value);
}

/// Records fatal logs instead of sending them to Crashlytics.
class _RecordingLogger extends LoggerService {
  final List<String> fatal = [];

  @override
  void f(String message, [dynamic error, StackTrace? stack]) => fatal.add(message);
}

void main() {
  late Directory hiveDir;

  setUp(() {
    hiveDir = Directory.systemTemp.createTempSync('hive_utils_test');
    Hive.init(hiveDir.path);
  });

  tearDown(() async {
    await Hive.close();
    Hive.resetAdapters();
    try {
      hiveDir.deleteSync(recursive: true);
    } on FileSystemException {
      // On Windows, Hive leaks a read handle after a failed open, which locks
      // the file until the test process exits. The OS temp dir is cleaned up
      // later.
    }
  });

  test('opens an existing box with its data', () async {
    final box = await Hive.openBox<int>('readings');
    await box.put('a', 1);
    await box.close();

    final reopened = await HiveUtils.openBoxSafely<int>(
      'readings',
      logger: _RecordingLogger(),
    );

    expect(reopened.get('a'), 1);
  });

  // Regression: a failed open used to delete the box (the user's records)
  // and silently start over with an empty one.
  test('keeps the box on disk, logs and rethrows when opening fails', () async {
    Hive.registerAdapter(_ReadingAdapter());
    final box = await Hive.openBox('readings');
    await box.put('a', _Reading(120));
    await box.close();
    Hive.resetAdapters(); // simulate a missing adapter / schema mismatch
    final logger = _RecordingLogger();
    Object? thrown;

    // Hive also completes an internal, unlistened future with the same
    // error; keep it from failing the test as an uncaught error.
    await runZonedGuarded(() async {
      try {
        await HiveUtils.openBoxSafely('readings', logger: logger);
      } catch (error) {
        thrown = error;
      }
    }, (_, __) {});

    expect(thrown, isA<HiveError>());
    expect(await Hive.boxExists('readings'), isTrue);
    expect(logger.fatal, hasLength(1));
  });
}
