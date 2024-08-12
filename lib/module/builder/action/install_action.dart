import 'package:app_builder/module/builder/action/base_action.dart';
import 'package:app_builder/module/builder/cli/adb_service.dart';
import 'package:app_builder/module/builder/cli/apk_service.dart';
import 'package:app_builder/module/builder/exception/build_action_exception.dart';
import 'package:app_builder/module/builder/exception/invalid_param_exception.dart';
import 'package:app_builder/utils/string_ext.dart';

class InstallAction extends BaseAction {
  InstallAction(super.preferenceService, super.task, super.logging);

  @override
  Future<void> run() async {
    final config = await preferenceService.getConfig();
    final adb = await AdbService.createAsync(preferenceService);

    final outputDir = task.outputDir;

    if (outputDir == null || outputDir.isBlank) {
      throw const InvalidParamException('Output folder is not set');
    }

    if (config?.installBuild == true) {
      final newestAPK = await ApkService.findLatest(outputDir);
      if (newestAPK == null) {
        throw BuildActionException(task.directory, 'No apk found to install');
      }

      final success = await adb.install(newestAPK);
      if (!success) {
        throw BuildActionException(task.directory, 'Install failed');
      }
    }
  }

  @override
  String get name => 'Install';
}
