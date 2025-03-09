import 'dart:developer' as developer;

/// {@template logger}
/// Task build logger.
/// {@endtemplate}
abstract class Logger {
  static const String _name = 'AppBuilder';

  /// Debug log.
  static void d(String tag, String message) {
    _log(tag, message, level: 500);
  }

  /// Info log.
  static void i(String tag, String message) {
    _log(tag, message, level: 800);
  }

  /// Warning log.
  static void w(String tag, String message) {
    _log(tag, message, level: 900);
  }

  /// Error log.
  static void e(String tag, String message) {
    _log(tag, message, level: 1000);
  }

  static void _log(
    String tag,
    String message, {
    required int level,
  }) {
    final formattedMessage = '[$tag]: $message';
    developer.log(formattedMessage, name: _name, level: level);
  }
}
