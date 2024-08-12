import 'dart:convert';
import 'dart:io';

import 'package:app_builder/module/builder/exception/invalid_param_exception.dart';
import 'package:app_builder/module/common/model/log_item.dart';
import 'package:app_builder/module/preference/preference_service.dart';
import 'package:app_builder/utils/logger.dart';
import 'package:app_builder/utils/string_ext.dart';
import 'package:rxdart/rxdart.dart';

class GradleService {
  GradleService._({
    required String javaHome,
    required this.directory,
    required this.logging,
  }) {
    _environment['JAVA_HOME'] = javaHome;
  }

  final Map<String, String> _environment = {};
  final String directory;
  final ReplaySubject<LogItem> logging;

  static Future<GradleService> createAsync({
    required PreferenceService preferenceService,
    required String directory,
    required ReplaySubject<LogItem> logging,
  }) async {
    final config = await preferenceService.getConfig();
    final javaHome = config?.javaHome;

    if (javaHome == null || javaHome.isBlank) {
      throw const InvalidParamException('JAVA_HOME is not set');
    }

    return GradleService._(
      javaHome: javaHome,
      directory: directory,
      logging: logging,
    );
  }

  Future<bool> build(String task, {String? flavor}) async {
    final String gradle;
    if (Platform.isWindows) {
      gradle = 'gradlew.bat';
    } else if (Platform.isLinux || Platform.isMacOS) {
      gradle = 'gradlew';
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    Logger.d('Start gradle build');

    final process = await Process.start(
      gradle,
      [task],
      environment: _environment,
      workingDirectory: directory,
      runInShell: true,
    );

    process.stdout.transform(utf8.decoder).listen((data) {
      logging.add(
        LogItem(taskDir: directory, message: data, level: LogLevel.stdout),
      );
    });

    process.stderr.transform(utf8.decoder).listen((data) {
      logging.add(
        LogItem(taskDir: directory, message: data, level: LogLevel.stderr),
      );
    });

    final exitCode = await process.exitCode;
    return exitCode == 0;
  }
}
