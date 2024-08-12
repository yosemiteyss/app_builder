sealed class SettingsEvent {}

final class OnConfigInit extends SettingsEvent {}

final class OnSetJavaHome extends SettingsEvent {}

final class OnSetAndroidHome extends SettingsEvent {}

final class OnSetGradleTask extends SettingsEvent {
  OnSetGradleTask(this.gradleTask);

  final String gradleTask;
}

final class OnSetStashChanges extends SettingsEvent {
  OnSetStashChanges(this.stashChanges);

  final bool stashChanges;
}

final class OnSetInstallBuild extends SettingsEvent {
  OnSetInstallBuild(this.installBuild);

  final bool installBuild;
}
