import 'package:task_builder/task_builder.dart';

/// {@template delete_output_action}
/// Delete all APK files from output directory.
/// {@endtemplate}
class DeleteOutputAction extends BaseAction {
  /// {@macro delete_output_action}
  DeleteOutputAction({
    required super.preferences,
    required super.task,
    required super.logging,
  });

  @override
  Future<void> run() async {
    final outputDir = task.outputDir;

    if (outputDir == null || outputDir.trim().isEmpty) {
      throw const InvalidParamException('Output folder is not set');
    }

    final isSuccess = await ApkService.deleteAll(outputDir);
    if (!isSuccess) {
      throw BuildException(
        directory: task.directory,
        message: 'Delete output failed.',
      );
    }
  }

  @override
  String get name => 'Delete Outputs';
}
