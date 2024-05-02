import 'package:app_builder/service/build/build_action.dart';
import 'package:app_builder/service/exception/build_action_exception.dart';
import 'package:app_builder/service/git_service.dart';

/// Stash uncommitted changes.
class StashAction extends BuildAction {
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
