part of 'tools_bloc.dart';

sealed class ToolsEvent extends Equatable {
  const ToolsEvent();
}

final class OnToolsInit extends ToolsEvent {
  const OnToolsInit();

  @override
  List<Object?> get props => [];
}

final class OnAddUninstallPackage extends ToolsEvent {
  const OnAddUninstallPackage({required this.packageName});

  final String packageName;

  @override
  List<Object?> get props => [packageName];
}

final class OnRemoveUninstallPackage extends ToolsEvent {
  const OnRemoveUninstallPackage({required this.package});

  final Package package;

  @override
  List<Object?> get props => [package];
}

final class OnUninstallPackages extends ToolsEvent {
  const OnUninstallPackages();

  @override
  List<Object?> get props => [];
}

final class OnUpdateDeviceId extends ToolsEvent {
  const OnUpdateDeviceId({required this.deviceId});

  final String deviceId;

  @override
  List<Object?> get props => [deviceId];
}

final class OnRefreshDevices extends ToolsEvent {
  const OnRefreshDevices();

  @override
  List<Object?> get props => [];
}
