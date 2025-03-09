import 'dart:io';

/// {@template cli_service}
/// Service class for running common commands.
/// {@endtemplate}
abstract class CliService {
  /// Check if an executable is installed.
  static Future<bool> which({required String target}) async {
    final String command;
    if (Platform.isWindows) {
      command = 'where';
    } else if (Platform.isLinux || Platform.isMacOS) {
      command = 'which';
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    final result = await Process.run(command, [target]);
    return result.exitCode == 0;
  }
}
