import 'dart:convert';
import 'dart:io';

import 'package:app_builder/module/builder/exception/invalid_git_dir_exception.dart';
import 'package:app_builder/utils/int_ext.dart';
import 'package:app_builder/utils/logger.dart';
import 'package:path/path.dart';

class GitService {
  GitService({required this.directory}) {
    if (!_isValidDirectory()) {
      throw InvalidGitDirException(directory);
    }
  }

  static const String _tag = 'GitService';

  final String directory;

  bool _isValidDirectory() {
    if (!Directory(directory).existsSync()) {
      return false;
    }
    return Directory('$directory/.git').existsSync();
  }

  Future<bool> diff() async {
    final result = await Process.run(
      'git',
      ['diff-index', '--quiet', 'HEAD', '--'],
      workingDirectory: directory,
      runInShell: true,
    );

    Logger.d(_tag, 'Diff: ${result.exitCode}');

    return result.exitCode == 0;
  }

  Future<bool> stash() async {
    final now = DateTime.now();
    final key =
        '${now.year}-${now.month.padZeroLeft(2)}-${now.day.padZeroLeft(2)}_${now.hour.padZeroLeft(2)}-${now.minute.padZeroLeft(2)}-${now.second.padZeroLeft(2)}';
    final message = '${basename(directory)}-$key';

    final result = await Process.run(
      'git',
      ['stash', 'save', message],
      workingDirectory: directory,
      runInShell: true,
    );

    Logger.d(_tag, 'Stashed: $message');

    return result.exitCode == 0;
  }

  Future<bool> checkout(String branch) async {
    final result = await Process.run(
      'git',
      ['checkout', branch],
      workingDirectory: directory,
      runInShell: true,
    );

    Logger.d(_tag, 'Check out branch: $branch');

    return result.exitCode == 0;
  }

  Future<List<String>> branches() async {
    final result = await Process.run(
      'git',
      ['branch'],
      workingDirectory: directory,
      runInShell: true,
    );

    if (result.exitCode == 0) {
      final branchesRaw = result.stdout.toString().trim();
      final branchesLines = const LineSplitter().convert(branchesRaw);

      final branches = branchesLines
          .map((line) =>
              line.startsWith('*') ? line.substring(1).trim() : line.trim())
          .toList();

      return branches;
    } else {
      Logger.e(_tag, 'Error running git branch: ${result.stderr}');
      return [];
    }
  }
}
