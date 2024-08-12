import 'dart:developer' as developer;

class Logger {
  static const String _tag = 'AppBuilder';

  static void d(String message, {Object? object, String tag = _tag}) {
    _log(object, message, level: 500, tag: tag);
  }

  static void i(String message, {Object? object, String tag = _tag}) {
    _log(object, message, level: 800, tag: tag);
  }

  static void w(String message, {Object? object, String tag = _tag}) {
    _log(object, message, level: 900, tag: tag);
  }

  static void e(String message, {Object? object, String tag = _tag}) {
    _log(object, message, level: 1000, tag: tag);
  }

  static void _log(
    Object? object,
    String message, {
    required int level,
    String tag = _tag,
  }) {
    final runtimeType = object?.runtimeType.toString() ?? 'Unknown';
    final formattedMessage = '[$runtimeType]: $message';
    developer.log(formattedMessage, name: tag, level: level);
  }
}
