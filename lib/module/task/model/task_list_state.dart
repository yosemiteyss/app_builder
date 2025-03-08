import 'package:app_builder/module/common/model/log_item.dart';
import 'package:app_builder/module/common/model/task.dart';
import 'package:app_builder/module/task/model/task_state.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class TaskListState extends Equatable {
  const TaskListState({
    this.isTaskLoading = true,
    this.isTaskAdding = false,
    this.tasksMap = const {},
    this.tasksLogs = const {},
  });

  final bool isTaskLoading;
  final bool isTaskAdding;
  final Map<String, Task> tasksMap;
  final Map<String, List<LogItem>> tasksLogs;

  TaskListState copyWith({
    bool? isTaskLoading,
    bool? isTaskAdding,
    Map<String, Task>? tasksMap,
    Map<String, List<LogItem>>? tasksLogs,
  }) {
    return TaskListState(
      isTaskLoading: isTaskLoading ?? this.isTaskLoading,
      isTaskAdding: isTaskAdding ?? this.isTaskAdding,
      tasksMap: tasksMap ?? this.tasksMap,
      tasksLogs: tasksLogs ?? this.tasksLogs,
    );
  }

  /// Returns sorted task list.
  List<Task> get taskListSorted {
    final taskList = tasksMap.values;
    return taskList.sortedBy((task) => task.name);
  }

  /// Returns any of the task exception.
  Exception? get taskException {
    final taskList = tasksMap.values;
    return taskList.map((e) => e.state).whereType<ErrorState>().firstOrNull?.e;
  }

  /// Return true if there is ongoing task.
  bool get isTaskOngoing {
    final taskList = tasksMap.values;
    return taskList.any((element) => element.state is OngoingState);
  }

  /// Return true if we can add new task to list.
  bool get allowTaskAdd {
    return !isTaskOngoing && !isTaskAdding && !isTaskLoading;
  }

  @override
  List<Object?> get props => [isTaskLoading, isTaskAdding, tasksMap, tasksLogs];
}
