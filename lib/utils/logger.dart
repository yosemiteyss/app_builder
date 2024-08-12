import 'dart:developer' as developer;

class Logger {
  static const String _name = 'AppBuilder';

  static void d(String tag, String message) {
    _log(tag, message, level: 500);
  }

  static void i(String tag, String message) {
    _log(tag, message, level: 800);
  }

  static void w(String tag, String message) {
    _log(tag, message, level: 900);
  }

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
