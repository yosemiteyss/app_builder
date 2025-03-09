part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
}

final class OnLoadPreferences extends SettingsEvent {
  const OnLoadPreferences();

  @override
  List<Object?> get props => [];
}

final class OnUpdateJavaHome extends SettingsEvent {
  const OnUpdateJavaHome();

  @override
  List<Object?> get props => [];
}

final class OnUpdateAndroidHome extends SettingsEvent {
  const OnUpdateAndroidHome();

  @override
  List<Object?> get props => [];
}

final class OnUpdateGradleTask extends SettingsEvent {
  const OnUpdateGradleTask(this.gradleTask);

  final String gradleTask;

  @override
  List<Object?> get props => [gradleTask];
}

final class OnUpdateStashChanges extends SettingsEvent {
  const OnUpdateStashChanges({required this.isStashChanges});

  final bool isStashChanges;

  @override
  List<Object?> get props => [isStashChanges];
}

final class OnUpdateInstallBuild extends SettingsEvent {
  const OnUpdateInstallBuild({required this.isInstallBuild});

  final bool isInstallBuild;

  @override
  List<Object?> get props => [isInstallBuild];
}
