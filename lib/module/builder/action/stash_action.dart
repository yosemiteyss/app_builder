import 'package:app_builder/module/builder/action/base_action.dart';
import 'package:app_builder/module/builder/cli/git_service.dart';
import 'package:app_builder/module/builder/exception/build_action_exception.dart';

/// Stash uncommitted changes.
class StashAction extends BaseAction {
  StashAction(super.preferenceService, super.task, super.logging);

  @override
  Future<void> run() async {
    final config = await preferenceService.getConfig();
    final git = GitService(directory: task.directory);

    final hasDiff = await git.diff();
    if (!hasDiff) {
      // no unsaved changes, skip stash.
      return;
    }

    final stashChanges = config?.stashChanges ?? false;
    if (!stashChanges) {
      return;
    }

    final success = await git.stash();
    if (!success) {
      throw BuildActionException(task.directory, 'Stash failed');
    }
  }

  @override
  String get name => 'Stash Changes';
}
