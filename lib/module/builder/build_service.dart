import 'dart:async';

import 'package:app_builder/module/builder/action/base_action.dart';
import 'package:app_builder/module/builder/action/checkout_action.dart';
import 'package:app_builder/module/builder/action/delete_output_action.dart';
import 'package:app_builder/module/builder/action/gradle_build_action.dart';
import 'package:app_builder/module/builder/action/gradle_stop_action.dart';
import 'package:app_builder/module/builder/action/install_action.dart';
import 'package:app_builder/module/builder/action/stash_action.dart';
import 'package:app_builder/module/common/model/log_item.dart';
import 'package:app_builder/module/common/model/task.dart';
import 'package:app_builder/module/preference/preference_service.dart';
import 'package:app_builder/module/task/model/task_state.dart';
import 'package:app_builder/utils/int_ext.dart';
import 'package:app_builder/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

class BuildService {
  BuildService(this._preferenceService);

  static const String _tag = 'BuildService';

  final StreamController<Task> _eventController = StreamController();
  final ReplaySubject<LogItem> _loggingController =
      ReplaySubject(maxSize: INT_MAX);

  final PreferenceService _preferenceService;

  Stream<Task> get eventStream => _eventController.stream;

  Stream<LogItem> get loggingStream => _loggingController.stream;

  Future<void> build(List<Task> tasks) async {
    // Set ongoing states for each task.
    for (final task in tasks) {
      _eventController.add(task.copyWith(state: TaskState.ongoing(null)));
    }

    for (final task in tasks) {
      await _buildEach(task);
    }
  }

  Future<void> _buildEach(Task task) async {
    try {
      Logger.d(_tag, 'Building: ${task.name}');

      final startTime = DateTime.now();

      final List<BaseAction> actions = [
        DeleteOutputAction(_preferenceService, task, _loggingController),
        StashAction(_preferenceService, task, _loggingController),
        CheckoutAction(_preferenceService, task, _loggingController),
        GradleBuildAction(_preferenceService, task, _loggingController),
        InstallAction(_preferenceService, task, _loggingController),
      ];

      // Emit ongoing state.
      for (final action in actions) {
        _eventController.add(
          task.copyWith(state: TaskState.ongoing(action.name)),
        );
        await action.run();
      }

      Logger.d(_tag, 'finished: ${task.name}');

      // Emit success state.
      final elapsed = DateTime.now().difference(startTime);
      _eventController.add(
        task.copyWith(state: TaskState.success(elapsed)),
      );
    } on Exception catch (e) {
      Logger.e(_tag, 'failed: ${task.name}, e: $e');

      // Emit error state.
      _eventController.add(
        task.copyWith(state: TaskState.error(e)),
      );
    }
  }

  Future<void> stopTask(Task task) async {
    final gradleStopAction = GradleStopAction(
      _preferenceService,
      task,
      _loggingController,
    );

    await gradleStopAction.run();
  }

  void dispose() {
    _eventController.close();
    _loggingController.close();
  }
}
