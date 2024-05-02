import 'package:app_builder/model/log_message.dart';
import 'package:app_builder/model/task.dart';
import 'package:app_builder/model/task_state.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class TaskListState extends Equatable {
  const TaskListState({
    this.isTaskAdding = false,
    this.tasksMap = const {},
    this.tasksLogs = const {},
  });

  final bool isTaskAdding;
  final Map<String, Task> tasksMap;
  final Map<String, List<LogMessage>> tasksLogs;

  TaskListState copyWith({
    bool? isTaskAdding,
    Map<String, Task>? tasksMap,
    Map<String, List<LogMessage>>? tasksLogs,
  }) {
    return TaskListState(
      isTaskAdding: isTaskAdding ?? this.isTaskAdding,
      tasksMap: tasksMap ?? this.tasksMap,
      tasksLogs: tasksLogs ?? this.tasksLogs,
    );
  }

  List<Task> get taskListSorted {
    final taskList = tasksMap.values;
    return taskList.sortedBy((task) => task.name);
  }

  Exception? get taskException {
    final taskList = tasksMap.values;
    return taskList.map((e) => e.state).whereType<ErrorState>().firstOrNull?.e;
  }

  bool get isTaskOngoing {
    final taskList = tasksMap.values;
    return taskList.any((element) => element.state is OngoingState);
  }

  bool get allowTaskAdd {
    return !isTaskOngoing && !isTaskAdding;
  }

  @override
  List<Object?> get props => [isTaskAdding, tasksMap, tasksLogs];
}
