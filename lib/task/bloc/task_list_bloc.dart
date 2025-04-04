import 'dart:async';
import 'dart:io';

import 'package:app_builder/utils/logger.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:task_builder/task_builder.dart';
import 'package:task_repository/task_repository.dart';

part 'task_list_event.dart';

part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc({
    required PreferencesRepository preferenceRepository,
    required TaskRepository taskRepository,
    required TaskBuilderService taskBuilderService,
  })  : _preferencesRepository = preferenceRepository,
        _taskRepository = taskRepository,
        _taskBuilderService = taskBuilderService,
        super(const TaskListState()) {
    on<OnLoadTasks>(_onLoadTasks);
    on<OnAddTask>(_onAddTask);
    on<OnRemoveTask>(_onRemoveTask);
    on<OnUpdateTask>(_onUpdateTask);
    on<OnStopTask>(_onStopTask);
    on<OnBuildTaskList>(_onBuildTaskList);
    on<OnBuildTask>(_onBuildTask);
    on<OnUpdateTaskOutputDir>(_onUpdateTaskOutputDir);
    on<OnUpdateTaskOrder>(_onUpdateTaskOrder);
    on<OnRefreshTaskBranch>(_onRefreshTaskBranch);
    on<OnTaskLogsUpdated>(_onTaskLogsUpdated);

    _onListenTaskEvent();
    _onListenTaskLogs();
  }

  static const String _tag = 'TaskListBloc';

  final PreferencesRepository _preferencesRepository;
  final TaskRepository _taskRepository;
  final TaskBuilderService _taskBuilderService;

  @override
  Future<void> close() {
    _taskBuilderService.dispose();
    return super.close();
  }

  void _onListenTaskEvent() {
    _taskBuilderService.eventStream.listen((task) {
      add(OnUpdateTask(task: task));
    });
  }

  void _onListenTaskLogs() {
    _taskBuilderService.loggingStream.listen((message) {
      final messageList = [...?state.tasksLogs[message.taskDir], message];
      final tasksLogs = Map.of(state.tasksLogs)
        ..[message.taskDir] = messageList;

      Logger.d(_tag, message.message);
      add(OnTaskLogsUpdated(tasksLogs: tasksLogs));
    });
  }

  Future<void> _onLoadTasks(
    OnLoadTasks event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      emit(state.copyWith(isTaskLoading: true));

      var tasksList = await _taskRepository.getTasks();
      tasksList = await Future.wait(tasksList.map(_onLoadTaskBranch));

      final tasksMap = <String, Task>{};

      // Update task index if not set.
      for (var (index, task) in tasksList.nonNulls.indexed) {
        if (task.index == -1) {
          task = task.copyWith(index: index);
        }
        tasksMap[task.directory] = task;
      }

      emit(state.copyWith(tasksMap: tasksMap, isTaskLoading: false));

      await _taskRepository.saveTasks(state.tasksOrdered.toList());
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<Task> _onLoadTaskBranch(Task task) async {
    try {
      final git = GitService(directory: task.directory);
      final branches = await git.branches();

      return task.copyWith(
        selectedBranch: task.selectedBranch ?? branches.firstOrNull,
        branches: branches,
      );
    } on Exception catch (error) {
      return task.copyWith(state: ErrorState(error));
    }
  }

  Future<void> _onAddTask(
    OnAddTask event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      final directories = await getDirectoryPaths();
      if (directories.isEmpty) {
        return;
      }

      emit(state.copyWith(isTaskAdding: true));

      final tasksMap = Map.of(state.tasksMap);

      for (final directory in directories) {
        if (directory != null && !state.tasksMap.keys.contains(directory)) {
          final config = await _preferencesRepository.getPreferences();
          final outputDir =
              join(directory, 'app', 'build', 'outputs', 'apk', 'snapshot');

          final task = Task(
            index: state.tasksMap.values.length,
            directory: directory,
            outputDir: Directory(outputDir).path,
            state: const IdleState(),
            gradleTask: config.gradleTask,
          );

          tasksMap[directory] = await _onLoadTaskBranch(task);
        }
      }

      emit(state.copyWith(tasksMap: tasksMap, isTaskAdding: false));

      await _taskRepository.saveTasks(state.tasksOrdered.toList());
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onRemoveTask(
    OnRemoveTask event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      final tasksMap = Map.of(state.tasksMap)..remove(event.task.directory);
      emit(state.copyWith(tasksMap: tasksMap));
      await _taskRepository.saveTasks(state.tasksOrdered.toList());
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onUpdateTask(
    OnUpdateTask event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      final tasksMap = Map.of(state.tasksMap)
        ..[event.task.directory] = event.task;
      emit(state.copyWith(tasksMap: tasksMap));
      await _taskRepository.saveTasks(state.tasksOrdered.toList());
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onStopTask(
    OnStopTask event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      final preferences = await _preferencesRepository.getPreferences();
      await _taskBuilderService.stopTask(
        task: event.task,
        preferences: preferences,
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onBuildTaskList(
    OnBuildTaskList event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      final tasks = state.tasksOrdered
          .whereNot((task) => task.isExcludeFromBuildAll ?? false)
          .toList();

      if (tasks.isNotEmpty) {
        emit(state.copyWith(tasksLogs: {}));

        final preferences = await _preferencesRepository.getPreferences();
        await _taskBuilderService.build(
          tasks: tasks,
          preferences: preferences,
          deviceId: event.deviceId,
        );
      }
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onBuildTask(
    OnBuildTask event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          tasksLogs: Map.of(state.tasksLogs)..remove(event.task.directory),
        ),
      );

      final task = state.tasksMap[event.task.directory];
      if (task != null) {
        final preferences = await _preferencesRepository.getPreferences();
        await _taskBuilderService.build(
          tasks: [task],
          preferences: preferences,
          deviceId: event.deviceId,
        );
      }
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onUpdateTaskOutputDir(
    OnUpdateTaskOutputDir event,
    Emitter<TaskListState> emit,
  ) async {
    try {
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
        await _taskRepository.saveTasks(state.tasksOrdered.toList());
      }
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  void _onUpdateTaskOrder(
    OnUpdateTaskOrder event,
    Emitter<TaskListState> emit,
  ) {
    final oldIndex = event.oldIndex;
    var newIndex = event.newIndex;

    if (event.oldIndex < newIndex) {
      newIndex -= 1;
    }

    final tasksOrdered = state.tasksOrdered.toList();
    final tasksMap = Map.of(state.tasksMap);

    // Remove the task from its old position, and insert it at the new
    // position with the updated index.
    final task = tasksOrdered.removeAt(oldIndex);
    tasksOrdered.insert(newIndex, task.copyWith(index: newIndex));

    // Update indexes in tasksMap.
    for (var i = 0; i < tasksOrdered.length; i++) {
      final updatedTask = tasksOrdered[i].copyWith(index: i);
      tasksMap[updatedTask.directory] = updatedTask;
    }

    emit(state.copyWith(tasksMap: tasksMap));
  }

  Future<void> _onRefreshTaskBranch(
    OnRefreshTaskBranch event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      final updatedTask = await _onLoadTaskBranch(event.task);
      final tasksMap = Map.of(state.tasksMap)
        ..[event.task.directory] = updatedTask;

      emit(state.copyWith(tasksMap: tasksMap));
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onTaskLogsUpdated(
    OnTaskLogsUpdated event,
    Emitter<TaskListState> emit,
  ) async {
    emit(state.copyWith(tasksLogs: event.tasksLogs));
  }
}
