import 'dart:io';

import 'package:app_builder/utils/logger.dart';
import 'package:collection/collection.dart';

abstract class ApkService {
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
      Logger.d('Found latest APK: ${latest?.path}');
      return latest;
    }

    return null;
  }

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

          Logger.d('Deleted APK: ${file.path}');
        }
      }
    }

    return true;
  }
}
