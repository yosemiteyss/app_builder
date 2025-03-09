import 'package:flutter/foundation.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_builder/src/cli/cli.dart';
import 'package:task_repository/task_repository.dart';

/// {@template base_action}
/// Base class for task build action.
/// {@endtemplate}
abstract class BaseAction {
  /// {@macro base_action}
  BaseAction({
    required this.preferences,
    required this.task,
    required this.logging,
  });

  /// Preferences.
  @protected
  final Preferences preferences;

  /// Task.
  @protected
  final Task task;

  /// Logging stream.
  @protected
  final ReplaySubject<LogItem> logging;

  /// The name of this action.
  String get name;

  /// Run build action.
  Future<void> run();
}
