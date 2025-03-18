part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();
}

final class OnUpdateDeviceId extends AppEvent {
  const OnUpdateDeviceId({required this.deviceId});

  final String deviceId;

  @override
  List<Object?> get props => [deviceId];
}

final class OnRefreshDevices extends AppEvent {
  const OnRefreshDevices();

  @override
  List<Object?> get props => [];
}
