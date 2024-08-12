import 'dart:io';

import 'package:app_builder/module/builder/exception/invalid_param_exception.dart';
import 'package:app_builder/module/preference/preference_service.dart';
import 'package:app_builder/utils/logger.dart';
import 'package:app_builder/utils/string_ext.dart';
import 'package:flutter/foundation.dart';

class AdbService {
  AdbService._({required String androidHome}) {
    _environment['ANDROID_HOME'] = androidHome;
  }

  final Map<String, String> _environment = {};

  static Future<AdbService> createAsync(
      PreferenceService preferenceService) async {
    final config = await preferenceService.getConfig();
    final androidHome = config?.androidHome;

    if (androidHome == null || androidHome.isBlank) {
      throw const InvalidParamException('ANDROID_HOME is not set');
    }

    return AdbService._(androidHome: androidHome);
  }

  Future<bool> install(File file) async {
    final result = await Process.run(
      'adb',
      ['install', '-r', '-t', file.path],
      environment: _environment,
      runInShell: true,
    );

    Logger.d('install: ${file.path}');

    return result.exitCode == 0;
  }

  Future<bool> uninstall(String package, String deviceId) async {
    final result = await Process.run(
      'adb',
      ['-s', deviceId, 'uninstall', package],
      environment: _environment,
    );

    Logger.d('uninstall: $package');

    return result.exitCode == 0;
  }

  Future<List<String>> getDevices() async {
    final result = await Process.run(
      'adb',
      ['devices'],
      environment: _environment,
      runInShell: true,
    );

    final List<String> devices = [];

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

  Stream<List<String>> getDevicesStream() async* {
    List<String> prevDevices = await getDevices();

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
