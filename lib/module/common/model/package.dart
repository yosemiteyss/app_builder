import 'package:app_builder/module/task/model/task_state.dart';

class Package {
  const Package({required this.name, required this.state});

  final String name;
  final TaskState state;

  Package copyWith({String? name, TaskState? state}) {
    return Package(
      name: name ?? this.name,
      state: state ?? this.state,
    );
  }
}
