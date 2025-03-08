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
    required ReplaySubject<LogItem> loggingController,
  }) : _loggingController = loggingController {
    _environment['JAVA_HOME'] = javaHome;
  }

  static const String _tag = 'GradleService';

  final Map<String, String> _environment = {};
  final ReplaySubject<LogItem> _loggingController;

  static Future<GradleService> createAsync({
    required PreferenceService preferenceService,
    required String directory,
    required ReplaySubject<LogItem> loggingController,
  }) async {
    final config = await preferenceService.getConfig();
    final javaHome = config?.javaHome;

    if (javaHome == null || javaHome.isBlank) {
      throw const InvalidParamException('JAVA_HOME is not set');
    }

    return GradleService._(
      javaHome: javaHome,
      loggingController: loggingController,
    );
  }

  Future<bool> build({
    required String taskName,
    required String directory,
    String? flavor,
  }) async {
    final gradle = _getGradleExecutableName();

    Logger.d(_tag, 'Start gradle build');

    final process = await Process.start(
      gradle,
      [taskName],
      environment: _environment,
      workingDirectory: directory,
      runInShell: true,
    );

    process.stdout.transform(utf8.decoder).listen((data) {
      _loggingController.add(
        LogItem(taskDir: directory, message: data, level: LogLevel.stdout),
      );
    });

    process.stderr.transform(utf8.decoder).listen((data) {
      _loggingController.add(
        LogItem(taskDir: directory, message: data, level: LogLevel.stderr),
      );
    });

    final exitCode = await process.exitCode;
    return exitCode == 0;
  }

  Future<bool> stop(String directory) async {
    final gradle = _getGradleExecutableName();

    final result = await Process.run(
      gradle,
      ['--stop'],
      environment: _environment,
      workingDirectory: directory,
      runInShell: true,
    );

    return result.exitCode == 0;
  }

  String _getGradleExecutableName() {
    if (Platform.isWindows) {
      return 'gradlew.bat';
    }

    if (Platform.isLinux || Platform.isMacOS) {
      return './gradlew';
    }

    throw UnsupportedError('Unsupported platform');
  }
}
