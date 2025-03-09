import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:task_builder/src/utils/logger.dart';
import 'package:task_builder/task_builder.dart';

/// {@template adb_service}
/// Service class for running adb commands.
/// {@endtemplate}
class AdbService {
  AdbService._({required String androidHome}) {
    _environment['ANDROID_HOME'] = androidHome;
  }

  static const String _tag = 'AdbService';

  final Map<String, String> _environment = {};

  /// Create [AdbService].
  static Future<AdbService> createAsync({required String? androidHome}) async {
    if (androidHome == null || androidHome.trim().isEmpty) {
      throw const InvalidParamException('ANDROID_HOME is not set');
    }

    return AdbService._(androidHome: androidHome);
  }

  /// Install APK file.
  Future<bool> install(File file) async {
    final result = await Process.run(
      'adb',
      ['install', '-r', '-t', file.path],
      environment: _environment,
      runInShell: true,
    );

    Logger.d(_tag, 'install: ${file.path}');

    return result.exitCode == 0;
  }

  /// Uninstall APK package from device.
  Future<bool> uninstall(String package, String deviceId) async {
    final result = await Process.run(
      'adb',
      ['-s', deviceId, 'uninstall', package],
      environment: _environment,
    );

    Logger.d(_tag, 'uninstall: $package');

    return result.exitCode == 0;
  }

  /// Get adb devices.
  Future<List<String>> getDevices() async {
    final result = await Process.run(
      'adb',
      ['devices'],
      environment: _environment,
      runInShell: true,
    );

    final devices = <String>[];

    if (result.exitCode != 0) {
      return devices;
    }

    // Parse the output from adb devices command
    final lines = result.stdout.toString().split('\n');
    for (final line in lines) {
      if (line.trim().endsWith('device') &&
          !line.trim().startsWith('List of devices')) {
        devices.add(line.split('\t').first);
      }
    }

    return devices;
  }

  /// Return stream of adb devices.
  Stream<List<String>> getDevicesStream() async* {
    var prevDevices = await getDevices();

    while (true) {
      await Future<void>.delayed(const Duration(seconds: 2));
      final currDevices = await getDevices();

      if (!listEquals(prevDevices, currDevices)) {
        yield currDevices;
        prevDevices = List.from(currDevices);
      }
    }
  }
}
