import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:task_builder/src/exception/exception.dart';
import 'package:task_builder/src/utils/utils.dart';

/// {@template git_service}
/// Service class for running git commands.
/// {@endtemplate}
class GitService {
  /// {@macro git_service}
  GitService({required this.directory}) {
    if (!_isGitDirectory()) {
      throw InvalidDirectoryException(directory);
    }
  }

  static const String _tag = 'GitService';

  /// The task directory.
  final String directory;

  bool _isGitDirectory() {
    if (!Directory(directory).existsSync()) {
      return false;
    }
    return Directory('$directory/.git').existsSync();
  }

  /// Check diff.
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

  /// Stash changes.
  Future<bool> stash() async {
    final now = DateTime.now();
    final key =
        '${now.year}-${now.month.padZeroLeft(2)}-${now.day.padZeroLeft(2)}_'
        '${now.hour.padZeroLeft(2)}-${now.minute.padZeroLeft(2)}-'
        '${now.second.padZeroLeft(2)}';
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

  /// Checkout branch.
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

  /// List branches.
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
          .map(
            (line) =>
                line.startsWith('*') ? line.substring(1).trim() : line.trim(),
          )
          .toList();

      return branches;
    } else {
      Logger.e(_tag, 'Error running git branch: ${result.stderr}');
      return [];
    }
  }
}
