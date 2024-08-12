import 'package:app_builder/module/builder/action/base_action.dart';
import 'package:app_builder/module/builder/cli/gradle_service.dart';
import 'package:app_builder/module/builder/exception/build_action_exception.dart';
import 'package:app_builder/module/builder/exception/invalid_param_exception.dart';
import 'package:app_builder/utils/string_ext.dart';

class GradleBuildAction extends BaseAction {
  GradleBuildAction(super.preferenceService, super.task, super.logging);

  @override
  Future<void> run() async {
    final gradle = await GradleService.createAsync(
      preferenceService: preferenceService,
      directory: task.directory,
      logging: logging,
    );

    final gradleTask = task.gradleTask;
    if (gradleTask == null || gradleTask.isBlank) {
      throw const InvalidParamException('Gradle task is not set');
    }

    final success = await gradle.build(gradleTask);
    if (!success) {
      throw BuildActionException(task.directory, 'Gradle build failed.');
    }
  }

  @override
  String get name => 'Gradle Build';
}
