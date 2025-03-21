part of 'task_list_bloc.dart';

sealed class TaskListEvent extends Equatable {
  const TaskListEvent();
}

final class OnLoadTasks extends TaskListEvent {
  const OnLoadTasks();

  @override
  List<Object?> get props => [];
}

final class OnAddTask extends TaskListEvent {
  const OnAddTask();

  @override
  List<Object?> get props => [];
}

final class OnRemoveTask extends TaskListEvent {
  const OnRemoveTask(this.task);

  final Task task;

  @override
  List<Object?> get props => [task];
}

final class OnUpdateTask extends TaskListEvent {
  const OnUpdateTask({required this.task, this.isSaveTask = true});

  final Task task;
  final bool isSaveTask;

  @override
  List<Object?> get props => [task, isSaveTask];
}

final class OnStopTask extends TaskListEvent {
  const OnStopTask({required this.task});

  final Task task;

  @override
  List<Object?> get props => [task];
}

final class OnBuildTaskList extends TaskListEvent {
  const OnBuildTaskList({required this.deviceId});

  final String? deviceId;

  @override
  List<Object?> get props => [deviceId];
}

final class OnBuildTask extends TaskListEvent {
  const OnBuildTask({
    required this.task,
    required this.deviceId,
  });

  final Task task;
  final String? deviceId;

  @override
  List<Object?> get props => [task, deviceId];
}

final class OnUpdateTaskOutputDir extends TaskListEvent {
  const OnUpdateTaskOutputDir({required this.task});

  final Task task;

  @override
  List<Object?> get props => [task];
}

final class OnUpdateTaskOrder extends TaskListEvent {
  const OnUpdateTaskOrder({
    required this.oldIndex,
    required this.newIndex,
  });

  final int oldIndex;
  final int newIndex;

  @override
  List<Object?> get props => [];
}

final class OnRefreshTaskBranch extends TaskListEvent {
  const OnRefreshTaskBranch({required this.task});

  final Task task;

  @override
  List<Object?> get props => [task];
}

final class OnTaskLogsUpdated extends TaskListEvent {
  const OnTaskLogsUpdated({required this.tasksLogs});

  final Map<String, List<LogItem>>? tasksLogs;

  @override
  List<Object?> get props => [tasksLogs];
}
