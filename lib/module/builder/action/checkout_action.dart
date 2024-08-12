import 'package:app_builder/module/builder/action/base_action.dart';
import 'package:app_builder/module/builder/cli/git_service.dart';
import 'package:app_builder/module/builder/exception/build_action_exception.dart';
import 'package:app_builder/module/builder/exception/invalid_param_exception.dart';
import 'package:app_builder/utils/string_ext.dart';

class CheckoutAction extends BaseAction {
  CheckoutAction(super.preferenceService, super.task, super.loggingController);

  @override
  Future<void> run() async {
    final git = GitService(directory: task.directory);
    final selectedBranch = task.selectedBranch;

    if (selectedBranch == null || selectedBranch.isBlank) {
      throw const InvalidParamException('Branch is not set');
    }

    final isSuccess = await git.checkout(selectedBranch);
    if (!isSuccess) {
      throw BuildActionException(task.directory, 'Checkout failed.');
    }
  }

  @override
  String get name => 'Checkout Branch';
}
