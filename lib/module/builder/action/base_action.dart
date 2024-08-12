import 'package:app_builder/module/common/model/log_item.dart';
import 'package:app_builder/module/common/model/task.dart';
import 'package:app_builder/module/preference/preference_service.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseAction {
  BaseAction(this.preferenceService, this.task, this.logging);

  @protected
  final PreferenceService preferenceService;

  @protected
  final Task task;

  @protected
  late final ReplaySubject<LogItem> logging;

  String get name;

  Future<void> run();
}
