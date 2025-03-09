import 'package:task_builder/task_builder.dart';

/// {@template stash_action}
/// Action for stashing uncommitted changes.
/// {@endtemplate}
class StashAction extends BaseAction {
  /// {@macro stash_action}
  StashAction({
    required super.preferences,
    required super.task,
    required super.logging,
  });

  @override
  Future<void> run() async {
    final git = GitService(directory: task.directory);

    final hasDiff = await git.diff();
    if (!hasDiff) {
      // no unsaved changes, skip stash.
      return;
    }

    if (!preferences.isStashChanges) {
      return;
    }

    final isSuccess = await git.stash();
    if (!isSuccess) {
      throw BuildException(
        directory: task.directory,
        message: 'Stash failed',
      );
    }
  }

  @override
  String get name => 'Stash Changes';
}
