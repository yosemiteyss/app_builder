import 'dart:async';
import 'dart:io';

import 'package:app_builder/module/builder/build_service.dart';
import 'package:app_builder/module/builder/cli/git_service.dart';
import 'package:app_builder/module/common/model/task.dart';
import 'package:app_builder/module/preference/preference_service.dart';
import 'package:app_builder/module/task/bloc/task_list_event.dart';
import 'package:app_builder/module/task/model/task_list_state.dart';
import 'package:app_builder/module/task/model/task_state.dart';
import 'package:app_builder/utils/logger.dart';
import 'package:collection/collection.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc(this._preferenceService, this._buildService)
      : super(const TaskListState()) {
    on<OnLoadTasks>(_onLoadTasks);
    on<OnAddTask>(_onAddTask);
    on<OnRemoveTask>(_onRemoveTask);
    on<OnUpdateTask>(_onUpdateTask);
    on<OnBuildTaskList>(_onBuildTaskList);
    on<OnBuildTask>(_onBuildTask);
    on<OnUpdateTaskOutputDir>(_onUpdateTaskOutputDir);
    on<OnRefreshTaskBranch>(_onRefreshTaskBranch);
    on<OnTaskLogsUpdated>(_onTaskLogsUpdated);

    _onListenEventUpdate();
    _onListenTaskLogsUpdate();
  }

  @override
  Future<void> close() {
    _buildService.dispose();
    return super.close();
  }

  final PreferenceService _preferenceService;
  final BuildService _buildService;

  void _onListenEventUpdate() {
    _buildService.eventStream.listen((task) {
      add(OnUpdateTask(task));
    });
  }

  void _onListenTaskLogsUpdate() {
    _buildService.loggingStream.listen((message) {
      final messageList = [...?state.tasksLogs[message.taskDir], message];
      final tasksLogs = Map.of(state.tasksLogs)
        ..[message.taskDir] = messageList;

      Logger.d(message.message);
      add(OnTaskLogsUpdated(tasksLogs));
    });
  }

  Future<void> _onLoadTasks(
    OnLoadTasks event,
    Emitter<TaskListState> emit,
  ) async {
    final tasks = await _preferenceService.getTasks();
    final futures = await Future.wait(tasks.map(_onLoadTaskBranch));
    final validTasks = futures.whereNotNull();

    final tasksMap = {for (final task in validTasks) task.directory: task};

    emit(state.copyWith(tasksMap: tasksMap));

    await _preferenceService.saveTasks(tasksMap.values.toList());
  }

  Future<Task> _onLoadTaskBranch(Task task) async {
    try {
      final git = GitService(directory: task.directory);
      final branches = await git.branches();

      return task.copyWith(
        selectedBranch: task.selectedBranch ?? branches.firstOrNull,
        branches: branches,
      );
    } on Exception catch (e) {
      return task.copyWith(state: TaskState.error(e));
    }
  }

  Future<void> _onAddTask(
    OnAddTask event,
    Emitter<TaskListState> emit,
  ) async {
    final directories = await getDirectoryPaths();
    if (directories.isEmpty) {
      return;
    }

    emit(state.copyWith(isTaskAdding: true));

    final tasksMap = Map.of(state.tasksMap);

    for (final directory in directories) {
      if (directory != null && !state.tasksMap.keys.contains(directory)) {
        final config = await _preferenceService.getConfig();
        final outputDir =
            join(directory, 'app', 'build', 'outputs', 'apk', 'snapshot');

        final task = Task(
          directory: directory,
          outputDir: Directory(outputDir).path,
          state: TaskState.idle(),
          gradleTask: config?.gradleTask,
        );

        tasksMap[directory] = await _onLoadTaskBranch(task);
      }
    }

    emit(state.copyWith(tasksMap: tasksMap, isTaskAdding: false));

    await _preferenceService.saveTasks(tasksMap.values.toList());
  }

  Future<void> _onRemoveTask(
    OnRemoveTask event,
    Emitter<TaskListState> emit,
  ) async {
    final tasksMap = Map.of(state.tasksMap)..remove(event.task.directory);
    emit(state.copyWith(tasksMap: tasksMap));
    await _preferenceService.saveTasks(tasksMap.values.toList());
  }

  Future<void> _onUpdateTask(
    OnUpdateTask event,
    Emitter<TaskListState> emit,
  ) async {
    final tasksMap = Map.of(state.tasksMap)
      ..[event.task.directory] = event.task;
    emit(state.copyWith(tasksMap: tasksMap));
    await _preferenceService.saveTasks(tasksMap.values.toList());
  }

  Future<void> _onBuildTaskList(
    OnBuildTaskList event,
    Emitter<TaskListState> emit,
  ) async {
    final tasks = state.tasksMap.values.toList();
    if (tasks.isNotEmpty) {
      emit(state.copyWith(tasksLogs: {}));
      await _buildService.build(tasks);
    }
  }

  Future<void> _onBuildTask(
    OnBuildTask event,
    Emitter<TaskListState> emit,
  ) async {
    emit(
      state.copyWith(
        tasksLogs: Map.of(state.tasksLogs)..remove(event.task.directory),
      ),
    );

    final t = state.tasksMap[event.task.directory];
    if (t != null) {
      await _buildService.build([t]);
    }
  }

  Future<void> _onUpdateTaskOutputDir(
    OnUpdateTaskOutputDir event,
    Emitter<TaskListState> emit,
  ) async {
    final directory = await getDirectoryPath(
      initialDirectory: event.task.directory,
    );

    if (directory != null) {
      final tasksMap = Map.of(state.tasksMap)
        ..update(
          event.task.directory,
          (value) => value.copyWith(outputDir: directory),
        );

      emit(state.copyWith(tasksMap: tasksMap));
      await _preferenceService.saveTasks(tasksMap.values.toList());
    }
  }

  Future<void> _onRefreshTaskBranch(
    OnRefreshTaskBranch event,
    Emitter<TaskListState> emit,
  ) async {
    final updatedTask = await _onLoadTaskBranch(event.task);
    final tasksMap = Map.of(state.tasksMap)
      ..[event.task.directory] = updatedTask;
    emit(state.copyWith(tasksMap: tasksMap));
  }

  Future<void> _onTaskLogsUpdated(
    OnTaskLogsUpdated event,
    Emitter<TaskListState> emit,
  ) async {
    emit(state.copyWith(tasksLogs: event.tasksLogs));
  }
}
