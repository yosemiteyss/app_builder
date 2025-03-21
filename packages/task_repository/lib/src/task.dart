import 'package:equatable/equatable.dart';
import 'package:path/path.dart';

/// {@template task_state}
/// State of a task.
/// {@endtemplate}
sealed class TaskState extends Equatable {
  /// {@macro task_state}
  const TaskState();
}

/// {@template idle_state}
/// Represent idle state for a task.
/// {@endtemplate}
class IdleState extends TaskState {
  /// {@macro idle_state}
  const IdleState();

  @override
  String toString() => 'IdleState';

  @override
  List<Object?> get props => [];
}

/// {@template success_state}
/// Represent success state for a task.
/// {@endtemplate}
class SuccessState extends TaskState {
  /// {@macro success_state}
  const SuccessState(this.elapsed);

  /// The elapsed build time.
  final Duration? elapsed;

  @override
  String toString() => 'SuccessState, elapsed: $elapsed';

  @override
  List<Object?> get props => [elapsed];
}

/// {@template ongoing_state}
/// Represent ongoing state for a task.
/// {@endtemplate}
class OngoingState extends TaskState {
  /// {@macro ongoing_state}
  const OngoingState(this.action);

  /// The ongoing action.
  final String? action;

  @override
  String toString() => 'OngoingState, action: $action';

  @override
  List<Object?> get props => [action];
}

/// {@template error_state}
/// Represent error state for a task.
/// {@endtemplate}
class ErrorState extends TaskState {
  /// {@macro error_state}
  const ErrorState(this.error);

  /// The error caught.
  final Exception? error;

  @override
  String toString() => 'ErrorState, error: $error';

  @override
  List<Object?> get props => [error];
}

/// {@template task}
/// The data of a task.
/// {@endtemplate}
class Task extends Equatable {
  /// {@macro task}
  const Task({
    required this.index,
    required this.directory,
    required this.state,
    this.branches = const [],
    this.gradleTask,
    this.outputDir,
    this.selectedBranch,
    this.isExpanded = true,
    this.isExcludeFromBuildAll,
  });

  /// Convert JSON to a [Task].
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      index: (json['index'] as int?) ?? -1,
      directory: json['directory'] as String,
      state: const IdleState(),
      gradleTask: json['gradle_task'] as String?,
      outputDir: json['output_dir'] as String?,
      selectedBranch: json['selected_branch'] as String?,
      isExcludeFromBuildAll: json['is_exclude_from_build_all'] as bool?,
    );
  }

  /// The task index.
  final int index;

  /// The project directory.
  final String directory;

  /// The task state.
  final TaskState state;

  /// List of git branches.
  final List<String> branches;

  /// The gradle task.
  final String? gradleTask;

  /// The output directory of APK.
  final String? outputDir;

  /// The selected branch.
  final String? selectedBranch;

  /// Whether the task item is expanded.
  final bool isExpanded;

  /// Whether to exclude the task from build all action.
  final bool? isExcludeFromBuildAll;

  /// The task name.
  String get name => basename(directory);

  /// Create a copy of [Task].
  Task copyWith({
    int? index,
    String? directory,
    TaskState? state,
    List<String>? branches,
    String? gradleTask,
    String? outputDir,
    String? selectedBranch,
    bool? isExpanded,
    bool? isExcludeFromBuildAll,
  }) {
    return Task(
      index: index ?? this.index,
      directory: directory ?? this.directory,
      state: state ?? this.state,
      branches: branches ?? this.branches,
      gradleTask: gradleTask ?? this.gradleTask,
      outputDir: outputDir ?? this.outputDir,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      isExpanded: isExpanded ?? this.isExpanded,
      isExcludeFromBuildAll:
          isExcludeFromBuildAll ?? this.isExcludeFromBuildAll,
    );
  }

  /// Convert [Task] to JSON.
  Map<String, dynamic> toJson() => {
        'index': index,
        'directory': directory,
        'gradle_task': gradleTask,
        'output_dir': outputDir,
        'selected_branch': selectedBranch,
        'is_exclude_from_build_all': isExcludeFromBuildAll,
      };

  @override
  List<Object?> get props => [
        index,
        directory,
        state,
        branches,
        gradleTask,
        outputDir,
        selectedBranch,
        isExpanded,
        isExcludeFromBuildAll,
      ];
}
