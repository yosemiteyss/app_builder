import 'package:app_builder/module/builder/action/base_action.dart';
import 'package:app_builder/module/builder/cli/apk_service.dart';
import 'package:app_builder/module/builder/exception/build_action_exception.dart';
import 'package:app_builder/module/builder/exception/invalid_param_exception.dart';
import 'package:app_builder/utils/string_ext.dart';

/// Delete all APK files from output directory.
class DeleteOutputAction extends BaseAction {
  DeleteOutputAction(super.preferenceService, super.task, super.loggingController);

  @override
  Future<void> run() async {
    final outputDir = task.outputDir;

    if (outputDir == null || outputDir.isBlank) {
      throw const InvalidParamException('Output folder is not set');
    }

    final isSuccess = await ApkService.deleteAll(outputDir);
    if (!isSuccess) {
      throw BuildActionException(task.directory, 'Delete output failed.');
    }
  }

  @override
  String get name => 'Delete Outputs';
}
