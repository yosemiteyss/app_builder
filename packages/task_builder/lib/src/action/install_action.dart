import 'package:task_builder/task_builder.dart';

/// {@template install_action}
/// Action for installing APK.
/// {@endtemplate}
class InstallAction extends BaseAction {
  /// {@macro install_action}
  InstallAction({
    required super.preferences,
    required super.task,
    required super.logging,
    required this.deviceId,
  });

  /// The id of the adb device.
  final String? deviceId;

  @override
  Future<void> run() async {
    final adb = await AdbService.createAsync(
      androidHome: preferences.androidHome,
    );

    final outputDir = task.outputDir;

    if (outputDir == null || outputDir.trim().isEmpty) {
      throw const InvalidParamException('Output folder is not set');
    }

    if (!preferences.isInstallBuild) {
      return;
    }

    if (deviceId == null) {
      throw const InvalidParamException('Device is not set');
    }

    final newestAPK = await ApkService.findLatest(outputDir);
    if (newestAPK == null) {
      throw BuildException(
        directory: task.directory,
        message: 'No apk found to install',
      );
    }

    final isSuccess = await adb.install(file: newestAPK, deviceId: deviceId!);
    if (!isSuccess) {
      throw BuildException(
        directory: task.directory,
        message: 'Install failed',
      );
    }
  }

  @override
  String get name => 'Install';
}
