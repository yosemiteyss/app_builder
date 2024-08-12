import 'dart:io';

abstract class CliService {
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
