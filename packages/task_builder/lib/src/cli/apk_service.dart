import 'dart:io';

import 'package:collection/collection.dart';
import 'package:task_builder/src/utils/logger.dart';

/// {@template apk_service}
/// Service class for managing APK files.
/// {@endtemplate}
abstract class ApkService {
  static const String _tag = 'ApkService';

  /// Return the last modified APK file from a directory.
  static Future<File?> findLatest(String directory) async {
    final dir = Directory(directory);
    if (dir.existsSync()) {
      final files = dir.listSync();
      final sortedApkFiles = files
          .where(
            (file) => file is File && file.path.toLowerCase().endsWith('.apk'),
          )
          .cast<File>()
          .sortedByCompare(
            (file) => file.lastModifiedSync(),
            (a, b) => b.compareTo(a),
          )
          .toList();

      final latest = sortedApkFiles.firstOrNull;
      Logger.d(_tag, 'Found latest APK: ${latest?.path}');
      return latest;
    }

    return null;
  }

  /// Delete all APK files from a directory.
  static Future<bool> deleteAll(String directory) async {
    final dir = Directory(directory);
    if (dir.existsSync()) {
      final files = dir.listSync();
      for (final file in files) {
        if (file is File && file.path.endsWith('.apk')) {
          try {
            await file.delete();
          } on FileSystemException {
            return false;
          }

          Logger.d(_tag, 'Deleted APK: ${file.path}');
        }
      }
    }

    return true;
  }
}
