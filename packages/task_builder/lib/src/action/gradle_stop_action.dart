import 'package:task_builder/task_builder.dart';

/// {@template gradle_stop_action}
/// Action for stopping gradle task.
/// {@endtemplate}
class GradleStopAction extends BaseAction {
  /// {@macro gradle_stop_action}
  GradleStopAction({
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

    await gradle.stop(task.directory);
  }

  @override
  String get name => 'Gradle Stop';
}
