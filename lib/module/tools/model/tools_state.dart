import 'package:app_builder/module/common/model/package.dart';

final class ToolsState {
  const ToolsState({
    this.packages = const [],
    this.deviceIds = const [],
    this.selectedDeviceId,
  });

  final List<Package> packages;
  final List<String> deviceIds;
  final String? selectedDeviceId;

  ToolsState copyWith({
    List<Package>? packages,
    List<String>? deviceIds,
    String? selectedDeviceId,
  }) {
    return ToolsState(
      packages: packages ?? this.packages,
      deviceIds: deviceIds ?? this.deviceIds,
      selectedDeviceId: selectedDeviceId ?? this.selectedDeviceId,
    );
  }
}
