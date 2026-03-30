import 'dart:developer' as developer;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Dedicated Logger service for GlucoCare.
/// Follows the architecture rule: "use a dedicated Logger service and send 
/// critical errors to Firebase Crashlytics".
class LoggerService {
  /// Info log - for non-critical information.
  void i(String message) {
    developer.log(message, name: 'INFO');
  }

  /// Warning log - for potential issues that are not yet errors.
  void w(String message, [dynamic error, StackTrace? stack]) {
    developer.log(message, name: 'WARNING', error: error, stackTrace: stack);
  }

  /// Error log - for caught exceptions. Reports to Crashlytics in production.
  void e(String message, [dynamic error, StackTrace? stack]) {
    developer.log(message, name: 'ERROR', error: error, stackTrace: stack);
    
    // In production, send to Crashlytics
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(
        error ?? message,
        stack,
        reason: message,
      );
    }
  }

  /// Fatal log - for critical app crashes or state corruption.
  /// Always reports to Crashlytics.
  void f(String message, [dynamic error, StackTrace? stack]) {
    developer.log(message, name: 'FATAL', error: error, stackTrace: stack);
    
    FirebaseCrashlytics.instance.recordError(
      error ?? message,
      stack,
      reason: message,
      fatal: true,
    );
  }
}
