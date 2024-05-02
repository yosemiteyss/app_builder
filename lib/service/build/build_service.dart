import 'dart:async';

import 'package:app_builder/model/log_message.dart';
import 'package:app_builder/model/task.dart';
import 'package:app_builder/model/task_state.dart';
import 'package:app_builder/service/build/build_action.dart';
import 'package:app_builder/service/build/checkout_action.dart';
import 'package:app_builder/service/build/delete_output_action.dart';
import 'package:app_builder/service/build/gradle_build_action.dart';
import 'package:app_builder/service/build/install_action.dart';
import 'package:app_builder/service/build/stash_action.dart';
import 'package:app_builder/service/preference_service.dart';
import 'package:app_builder/utils/int_ext.dart';
import 'package:app_builder/utils/logging.dart';
import 'package:rxdart/rxdart.dart';

class BuildService with Logging {
  BuildService(this._preferenceService);

  final StreamController<Task> _eventController = StreamController();
  final ReplaySubject<LogMessage> _loggingController =
      ReplaySubject(maxSize: INT_MAX);

  final PreferenceService _preferenceService;

  Stream<Task> get eventStream => _eventController.stream;

  Stream<LogMessage> get loggingStream => _loggingController.stream;

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
      log('Building: ${task.name}');

      final startTime = DateTime.now();

      final List<BuildAction> actions = [
        DeleteOutputAction(_preferenceService, task, _loggingController),
        StashAction(_preferenceService, task, _loggingController),
        CheckoutAction(_preferenceService, task, _loggingController),
        GradleBuildAction(_preferenceService, task, _loggingController),
        InstallAction(_preferenceService, task, _loggingController),
      ];

      for (final action in actions) {
        _eventController.add(
          task.copyWith(state: TaskState.ongoing(action.name)),
        );
        await action.run();
      }

      log('finished: ${task.name}');

      final elapsed = DateTime.now().difference(startTime);
      _eventController.add(task.copyWith(state: TaskState.success(elapsed)));
    } on Exception catch (e) {
      log('failed: ${task.name}, e: $e');
      _eventController.add(task.copyWith(state: TaskState.error(e)));
    }
  }

  void dispose() {
    _eventController.close();
    _loggingController.close();
  }
}
