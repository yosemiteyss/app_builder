import 'package:app_builder/model/log_message.dart';
import 'package:app_builder/model/task.dart';
import 'package:app_builder/service/preference_service.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class BuildAction {
  BuildAction(this.preferenceService, this.task, this.logging);

  @protected
  final PreferenceService preferenceService;

  @protected
  final Task task;

  @protected
  late final ReplaySubject<LogMessage> logging;

  String get name;

  Future<void> run();
}
