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

  static const String _cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.medicationsBox,
    required this.doseHistoryBox,
    required this.userBox,
    required this.insulinReadingsBox,
    required this.labTestsBox,
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
    // Clearing all local Hive boxes instead of deleting from disk to keep them open for reuse
    try {
      await medicationsBox.clear();
      await doseHistoryBox.clear();
      await userBox.clear();
      await insulinReadingsBox.clear();
      await labTestsBox.clear();
    } catch (e) {
      // Ignore if boxes are already closed or errors
    }
  }
}
