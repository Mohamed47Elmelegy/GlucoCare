import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../storage/shared_prefs_utils.dart';

class LocaleCubit extends Cubit<Locale> {
  final SharedPrefsUtils _sharedPrefsUtils;
  static const String _localeKey = 'app_locale';

  LocaleCubit(this._sharedPrefsUtils) : super(const Locale('en')) {
    _loadLocale();
  }

  void _loadLocale() {
    final savedLocale = _sharedPrefsUtils.getString(_localeKey);
    if (savedLocale == null) {
      // Default to system locale if possible, or 'en'
      emit(const Locale('en'));
      return;
    }
    emit(Locale(savedLocale));
  }

  void updateLocale(String languageCode) {
    emit(Locale(languageCode));
    _sharedPrefsUtils.setString(_localeKey, languageCode);
  }
}
