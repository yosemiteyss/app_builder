import 'package:app_builder/module/common/model/log_item.dart';
import 'package:app_builder/module/common/model/task.dart';

sealed class TaskListEvent {}

final class OnLoadTasks extends TaskListEvent {}

final class OnAddTask extends TaskListEvent {}

final class OnRemoveTask extends TaskListEvent {
  OnRemoveTask(this.task);

  final Task task;
}

final class OnUpdateTask extends TaskListEvent {
  OnUpdateTask(this.task, {this.save = true});

  final Task task;
  final bool save;
}

final class OnBuildTaskList extends TaskListEvent {}

final class OnBuildTask extends TaskListEvent {
  OnBuildTask(this.task);

  final Task task;
}

final class OnUpdateTaskOutputDir extends TaskListEvent {
  OnUpdateTaskOutputDir(this.task);

  final Task task;
}

final class OnRefreshTaskBranch extends TaskListEvent {
  OnRefreshTaskBranch(this.task);

  final Task task;
}

final class OnTaskLogsUpdated extends TaskListEvent {
  OnTaskLogsUpdated(this.tasksLogs);

  final Map<String, List<LogItem>>? tasksLogs;
}
