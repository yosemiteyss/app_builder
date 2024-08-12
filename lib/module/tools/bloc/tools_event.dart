import 'package:app_builder/module/common/model/package.dart';

sealed class ToolsEvent {}

final class OnToolsInit extends ToolsEvent {}

final class OnAddUninstallPackage extends ToolsEvent {
  OnAddUninstallPackage(this.packageName);

  final String packageName;
}

final class OnRemoveUninstallPackage extends ToolsEvent {
  OnRemoveUninstallPackage(this.package);

  final Package package;
}

final class OnUninstallPackages extends ToolsEvent {}

final class OnSetDeviceId extends ToolsEvent {
  OnSetDeviceId(this.deviceId);

  final String deviceId;
}

final class OnRefreshDevices extends ToolsEvent {}
