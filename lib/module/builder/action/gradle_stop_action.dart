import 'package:app_builder/module/builder/action/base_action.dart';
import 'package:app_builder/module/builder/cli/gradle_service.dart';

class GradleStopAction extends BaseAction {
  GradleStopAction(
    super.preferenceService,
    super.task,
    super.loggingController,
  );

  @override
  String get name => 'Gradle Stop';

  @override
  Future<void> run() async {
    final gradle = await GradleService.createAsync(
      preferenceService: preferenceService,
      directory: task.directory,
      loggingController: loggingController,
    );

    await gradle.stop(task.directory);
  }
}
