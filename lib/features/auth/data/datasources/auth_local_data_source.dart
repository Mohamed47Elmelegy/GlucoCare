import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final Box medicationsBox;
  final Box doseHistoryBox;
  final Box userBox;
  final Box insulinReadingsBox;
  final Box labTestsBox;
  final Box intakeTasksBox;

  static const String _cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.medicationsBox,
    required this.doseHistoryBox,
    required this.userBox,
    required this.insulinReadingsBox,
    required this.labTestsBox,
    required this.intakeTasksBox,
  });

  @override
  Future<void> cacheUser(UserModel user) async {
    final String userJson = jsonEncode(user.toJson());
    await secureStorage.write(key: _cachedUserKey, value: userJson);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final String? userJson = await secureStorage.read(key: _cachedUserKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await secureStorage.delete(key: _cachedUserKey);
    // Clear (not delete) every box so they stay open for the next user.
    // Errors propagate: a failed clear would leave this user's health data on
    // the device, so the caller must find out.
    await medicationsBox.clear();
    await doseHistoryBox.clear();
    await userBox.clear();
    await insulinReadingsBox.clear();
    await labTestsBox.clear();
    await intakeTasksBox.clear();
  }
}
