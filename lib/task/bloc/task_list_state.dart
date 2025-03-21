part of 'task_list_bloc.dart';

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

  /// Returns ordered task list.
  List<Task> get tasksOrdered {
    return tasksMap.values.sortedBy<num>((task) => task.index);
  }

  /// Returns any of the task exception.
  Exception? get taskException {
    return tasksMap.values
        .map((e) => e.state)
        .whereType<ErrorState>()
        .firstOrNull
        ?.error;
  }

  /// Return true if there is ongoing task.
  bool get isTaskOngoing {
    return tasksMap.values.any((element) => element.state is OngoingState);
  }

  /// Return true if we can add new task to list.
  bool get allowTaskAdd {
    return !isTaskOngoing && !isTaskAdding && !isTaskLoading;
  }

  @override
  List<Object?> get props => [
        isTaskLoading,
        isTaskAdding,
        tasksMap,
        tasksLogs,
      ];
}
