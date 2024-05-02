import 'dart:developer' as dev;

mixin class Logging {
  void log(String message) {
    dev.log('[$runtimeType] $message');
  }
}
