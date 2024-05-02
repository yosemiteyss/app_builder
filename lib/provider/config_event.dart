sealed class ConfigEvent {}

final class OnConfigInit extends ConfigEvent {}

final class OnSetJavaHome extends ConfigEvent {}

final class OnSetAndroidHome extends ConfigEvent {}

final class OnSetGradleTask extends ConfigEvent {
  OnSetGradleTask(this.gradleTask);

  final String gradleTask;
}

final class OnSetStashChanges extends ConfigEvent {
  OnSetStashChanges(this.stashChanges);

  final bool stashChanges;
}

final class OnSetInstallBuild extends ConfigEvent {
  OnSetInstallBuild(this.installBuild);

  final bool installBuild;
}
