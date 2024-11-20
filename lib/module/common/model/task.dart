import 'package:app_builder/module/task/model/task_state.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';

class Task extends Equatable {
  const Task(
      {required this.directory,
      required this.state,
      this.branches = const [],
      this.gradleTask,
      this.outputDir,
      this.selectedBranch,
      this.isExpanded = true,
      this.isExcludeFromBuildAll});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        directory: json['directory'],
        state: TaskState.idle(),
        gradleTask: json['gradle_task'],
        outputDir: json['output_dir'],
        selectedBranch: json['selected_branch'],
        isExcludeFromBuildAll: json['is_exclude_from_build_all']);
  }

  final String directory;
  final String? selectedBranch;
  final String? gradleTask;
  final String? outputDir;
  final List<String> branches;
  final TaskState state;
  final bool isExpanded;
  final bool? isExcludeFromBuildAll;

  String get name => basename(directory);

  Task copyWith({
    String? name,
    String? directory,
    String? selectedBranch,
    String? gradleTask,
    String? outputDir,
    TaskState? state,
    List<String>? branches,
    bool? isExpanded,
    bool? isLoadingBranch,
    bool? isExcludeFromBuildAll,
  }) {
    return Task(
      directory: directory ?? this.directory,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      gradleTask: gradleTask ?? this.gradleTask,
      outputDir: outputDir ?? this.outputDir,
      state: state ?? this.state,
      branches: branches ?? this.branches,
      isExpanded: isExpanded ?? this.isExpanded,
      isExcludeFromBuildAll:
          isExcludeFromBuildAll ?? this.isExcludeFromBuildAll,
    );
  }

  Map<String, dynamic> toJson() => {
        'directory': directory,
        'gradle_task': gradleTask,
        'output_dir': outputDir,
        'selected_branch': selectedBranch,
        'is_exclude_from_build_all': isExcludeFromBuildAll,
      };

  @override
  List<Object?> get props => [
        directory,
        selectedBranch,
        gradleTask,
        outputDir,
        branches,
        state,
        isExpanded,
        isExcludeFromBuildAll,
      ];
}
