import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_builder/src/exception/invalid_param_exception.dart';
import 'package:task_builder/src/utils/logger.dart';

/// {@template log_level}
/// Log level.
/// {@endtemplate}
enum LogLevel {
  /// Logs from stdout.
  stdout,

  /// Logs from stderr.
  stderr
}

/// {@template log_item}
/// A log statement item.
/// {@endtemplate}
class LogItem extends Equatable {
  /// {@macro log_item}
  const LogItem({
    required this.taskDir,
    required this.message,
    required this.level,
  });

  /// The task directory.
  final String taskDir;

  /// The log message.
  final String message;

  /// The log level.
  final LogLevel level;

  @override
  List<Object?> get props => [taskDir, message, level];
}

/// {@template gradle_service}
/// Service class for running gradle commands.
/// {@endtemplate}
class GradleService {
  /// {@macro gradle_service}
  GradleService._({
    required String javaHome,
    required ReplaySubject<LogItem> logging,
  }) : _logging = logging {
    _environment['JAVA_HOME'] = javaHome;
  }

  static const String _tag = 'GradleService';

  final Map<String, String> _environment = {};
  final ReplaySubject<LogItem> _logging;

  /// Create [GradleService].
  static Future<GradleService> createAsync({
    required String? javaHome,
    required String directory,
    required ReplaySubject<LogItem> logging,
  }) async {
    if (javaHome == null || javaHome.trim().isEmpty) {
      throw const InvalidParamException('JAVA_HOME is not set');
    }

    return GradleService._(
      javaHome: javaHome,
      logging: logging,
    );
  }

  /// Run gradle build.
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
      _logging.add(
        LogItem(taskDir: directory, message: data, level: LogLevel.stdout),
      );
    });

    process.stderr.transform(utf8.decoder).listen((data) {
      _logging.add(
        LogItem(taskDir: directory, message: data, level: LogLevel.stderr),
      );
    });

    final exitCode = await process.exitCode;
    return exitCode == 0;
  }

  /// Stop gradle build.
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
