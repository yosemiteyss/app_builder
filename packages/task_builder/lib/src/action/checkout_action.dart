import 'package:task_builder/task_builder.dart';

/// {@template checkout_action}
/// Action for check out a branch.
/// {@endtemplate}
class CheckoutAction extends BaseAction {
  /// {@macro checkout_action}
  CheckoutAction({
    required super.preferences,
    required super.task,
    required super.logging,
  });

  @override
  Future<void> run() async {
    final git = GitService(directory: task.directory);
    final selectedBranch = task.selectedBranch;

    if (selectedBranch == null || selectedBranch.trim().isEmpty) {
      throw const InvalidParamException('Branch is not set');
    }

    final isSuccess = await git.checkout(selectedBranch);
    if (!isSuccess) {
      throw BuildException(
        directory: task.directory,
        message: 'Checkout failed.',
      );
    }
  }

  @override
  String get name => 'Checkout Branch';
}
