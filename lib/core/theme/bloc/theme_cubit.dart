import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../storage/shared_prefs_utils.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPrefsUtils _sharedPrefsUtils;
  static const String _themeKey = 'theme_mode';

  ThemeCubit(this._sharedPrefsUtils) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = _sharedPrefsUtils.getString(_themeKey);
    if (savedTheme == null) {
      emit(ThemeMode.system);
      return;
    }

    switch (savedTheme) {
      case 'light':
        emit(ThemeMode.light);
        break;
      case 'dark':
        emit(ThemeMode.dark);
        break;
      default:
        emit(ThemeMode.system);
    }
  }

  void updateTheme(ThemeMode mode) {
    emit(mode);
    String themeString;
    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      default:
        themeString = 'system';
    }
    _sharedPrefsUtils.setString(_themeKey, themeString);
  }
}
