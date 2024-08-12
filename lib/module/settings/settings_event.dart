sealed class SettingsEvent {}

final class OnSettingsInit extends SettingsEvent {}

final class OnUpdateJavaHome extends SettingsEvent {}

final class OnUpdateAndroidHome extends SettingsEvent {}

final class OnUpdateGradleTask extends SettingsEvent {
  OnUpdateGradleTask(this.gradleTask);

  final String gradleTask;
}

final class OnUpdateStashChanges extends SettingsEvent {
  OnUpdateStashChanges(this.isStashChanges);

  final bool isStashChanges;
}

final class OnUpdateInstallBuild extends SettingsEvent {
  OnUpdateInstallBuild(this.installBuild);

  final bool installBuild;
}
