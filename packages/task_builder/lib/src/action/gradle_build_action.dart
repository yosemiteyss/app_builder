import 'package:task_builder/task_builder.dart';

/// {@template gradle_build_action}
/// Action for running gradle build.
/// {@endtemplate}
class GradleBuildAction extends BaseAction {
  /// {@macro gradle_build_action}
  GradleBuildAction({
    required super.preferences,
    required super.task,
    required super.logging,
  });

  @override
  Future<void> run() async {
    final gradle = await GradleService.createAsync(
      javaHome: preferences.javaHome,
      directory: task.directory,
      logging: logging,
    );

    final taskName = task.gradleTask;
    if (taskName == null || taskName.trim().isEmpty) {
      throw const InvalidParamException('Gradle task is not set');
    }

    final isSuccess = await gradle.build(
      taskName: taskName,
      directory: task.directory,
    );

    if (!isSuccess) {
      throw BuildException(
        directory: task.directory,
        message: 'Gradle build failed.',
      );
    }
  }

  @override
  String get name => 'Gradle Build';
}
