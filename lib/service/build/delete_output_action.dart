import 'package:app_builder/service/apk_service.dart';
import 'package:app_builder/service/build/build_action.dart';
import 'package:app_builder/service/exception/build_action_exception.dart';
import 'package:app_builder/service/exception/invalid_param_exception.dart';
import 'package:app_builder/utils/string_ext.dart';

/// Delete all APK files from output directory.
class DeleteOutputAction extends BuildAction {
  DeleteOutputAction(super.preferenceService, super.task, super.logging);

  @override
  Future<void> run() async {
    final outputDir = task.outputDir;

    if (outputDir == null || outputDir.isBlank) {
      throw const InvalidParamException('Output folder is not set');
    }

    final success = await ApkService.deleteAll(outputDir);
    if (!success) {
      throw BuildActionException(task.directory, 'Delete output failed.');
    }
  }

  @override
  String get name => 'Delete Outputs';
}
