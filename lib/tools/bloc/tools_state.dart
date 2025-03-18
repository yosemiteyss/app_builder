part of 'tools_bloc.dart';

class Package extends Equatable {
  const Package({required this.name, required this.state});

  final String name;
  final TaskState state;

  Package copyWith({String? name, TaskState? state}) {
    return Package(
      name: name ?? this.name,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [name, state];
}

class ToolsState extends Equatable {
  const ToolsState({
    this.uninstallPackages = const [],
  });

  final List<Package> uninstallPackages;

  ToolsState copyWith({
    List<Package>? uninstallPackages,
  }) {
    return ToolsState(
      uninstallPackages: uninstallPackages ?? this.uninstallPackages,
    );
  }

  @override
  List<Object?> get props => [uninstallPackages];
}
