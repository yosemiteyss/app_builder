import 'package:app_builder/service/build/build_action.dart';
import 'package:app_builder/service/exception/build_action_exception.dart';
import 'package:app_builder/service/exception/invalid_param_exception.dart';
import 'package:app_builder/service/git_service.dart';
import 'package:app_builder/utils/string_ext.dart';

/// Checkout branch.
class CheckoutAction extends BuildAction {
  CheckoutAction(super.preferenceService, super.task, super.logging);

  @override
  Future<void> run() async {
    final git = GitService(directory: task.directory);
    final selectedBranch = task.selectedBranch;

    if (selectedBranch == null || selectedBranch.isBlank) {
      throw const InvalidParamException('Branch is not set');
    }

    final success = await git.checkout(selectedBranch);
    if (!success) {
      throw BuildActionException(task.directory, 'Checkout failed.');
    }
  }

  @override
  String get name => 'Checkout Branch';
}
