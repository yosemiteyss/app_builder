part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    this.deviceIds = const [],
    this.selectedDeviceId,
  });

  /// List of adb devices.
  final List<String> deviceIds;

  /// The id of the selected adb device.
  final String? selectedDeviceId;

  AppState copyWith({
    List<String>? deviceIds,
    String? selectedDeviceId,
  }) {
    return AppState(
      deviceIds: deviceIds ?? this.deviceIds,
      selectedDeviceId: selectedDeviceId ?? this.selectedDeviceId,
    );
  }

  @override
  List<Object?> get props => [deviceIds, selectedDeviceId];
}
