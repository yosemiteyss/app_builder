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
    this.deviceIds = const [],
    this.selectedDeviceId,
  });

  final List<Package> uninstallPackages;
  final List<String> deviceIds;
  final String? selectedDeviceId;

  ToolsState copyWith({
    List<Package>? uninstallPackages,
    List<String>? deviceIds,
    String? selectedDeviceId,
  }) {
    return ToolsState(
      uninstallPackages: uninstallPackages ?? this.uninstallPackages,
      deviceIds: deviceIds ?? this.deviceIds,
      selectedDeviceId: selectedDeviceId ?? this.selectedDeviceId,
    );
  }

  @override
  List<Object?> get props => [
        uninstallPackages,
        deviceIds,
        selectedDeviceId,
      ];
}
