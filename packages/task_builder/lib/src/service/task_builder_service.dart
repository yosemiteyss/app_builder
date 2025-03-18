import 'dart:async';

import 'package:preferences_repository/preferences_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_builder/src/utils/utils.dart';
import 'package:task_builder/task_builder.dart';
import 'package:task_repository/task_repository.dart';

/// {@template task_builder_service}
/// Task builder service.
/// {@endtemplate}
class TaskBuilderService {
  /// {@macro task_builder_service}
  TaskBuilderService();

  static const String _tag = 'TaskBuilderService';

  final StreamController<Task> _eventController = StreamController();
  final ReplaySubject<LogItem> _loggingController =
      ReplaySubject(maxSize: INT_MAX);

  /// Stream for task events.
  Stream<Task> get eventStream => _eventController.stream;

  /// Stream for log events.
  Stream<LogItem> get loggingStream => _loggingController.stream;

  /// Build tasks.
  Future<void> build({
    required List<Task> tasks,
    required Preferences preferences,
    required String? deviceId,
  }) async {
    for (final task in tasks) {
      _eventController.add(
        task.copyWith(state: const OngoingState(null)),
      );
    }

    for (final task in tasks) {
      await _buildTask(
        task: task,
        preferences: preferences,
        deviceId: deviceId,
      );
    }
  }

  Future<void> _buildTask({
    required Task task,
    required Preferences preferences,
    required String? deviceId,
  }) async {
    try {
      Logger.d(_tag, 'Building: ${task.name}');

      final startTime = DateTime.now();

      final actions = <BaseAction>[
        DeleteOutputAction(
          preferences: preferences,
          task: task,
          logging: _loggingController,
        ),
        StashAction(
          preferences: preferences,
          task: task,
          logging: _loggingController,
        ),
        CheckoutAction(
          preferences: preferences,
          task: task,
          logging: _loggingController,
        ),
        GradleBuildAction(
          preferences: preferences,
          task: task,
          logging: _loggingController,
        ),
        InstallAction(
          preferences: preferences,
          task: task,
          logging: _loggingController,
          deviceId: deviceId,
        ),
      ];

      // Emit ongoing state.
      for (final action in actions) {
        _eventController.add(task.copyWith(state: OngoingState(action.name)));
        await action.run();
      }

      Logger.d(_tag, 'finished: ${task.name}');

      // Emit success state.
      final elapsed = DateTime.now().difference(startTime);
      _eventController.add(task.copyWith(state: SuccessState(elapsed)));
    } on Exception catch (e) {
      Logger.e(_tag, 'failed: ${task.name}, e: $e');

      // Emit error state.
      _eventController.add(task.copyWith(state: ErrorState(e)));
    }
  }

  /// Stop building task.
  Future<void> stopTask({
    required Task task,
    required Preferences preferences,
  }) async {
    final gradleStopAction = GradleStopAction(
      preferences: preferences,
      task: task,
      logging: _loggingController,
    );

    await gradleStopAction.run();
  }

  /// Dispose service.
  void dispose() {
    _eventController.close();
    _loggingController.close();
  }
}
