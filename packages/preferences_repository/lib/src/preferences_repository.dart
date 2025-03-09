import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:storage/storage.dart';

/// {@template preferences_exception}
/// Exception class for preferences failures.
/// {@endtemplate}
class PreferencesException with EquatableMixin implements Exception {
  /// {@macro preferences_exception}
  const PreferencesException(this.error);

  /// The error caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template preferences_repository}
/// Repository for managing user preferences.
/// {@endtemplate}
class PreferencesRepository {
  /// {@macro preferences_repository}
  const PreferencesRepository({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  /// Storage key for preferences.
  static const String preferencesStorageKey = 'env';

  /// Storage key for uninstall packages.
  static const String uninstallPackagesStorageKey = 'uninstall_pkgs';

  /// Get user preferences data.
  Future<Preferences> getPreferences() async {
    try {
      final jsonString = await _storage.read(key: preferencesStorageKey);
      if (jsonString == null) {
        return const Preferences();
      }

      final jsonDecoded = jsonDecode(jsonString) as Map<String, dynamic>;
      return Preferences.fromJson(jsonDecoded);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(PreferencesException(error), stackTrace);
    }
  }

  /// Save user preferences data.
  Future<void> savePreferences(Preferences preferences) async {
    try {
      final jsonEncoded = jsonEncode(preferences.toJson());
      await _storage.write(key: preferencesStorageKey, value: jsonEncoded);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(PreferencesException(error), stackTrace);
    }
  }

  /// Get uninstall packages.
  Future<List<String>> getUninstallPackages() async {
    try {
      final jsonString = await _storage.read(key: uninstallPackagesStorageKey);
      if (jsonString == null) {
        return const [];
      }

      final jsonDecoded = jsonDecode(jsonString) as List<dynamic>;
      return jsonDecoded.map((e) => e.toString()).toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(PreferencesException(error), stackTrace);
    }
  }

  /// Save uninstall packages.
  Future<void> saveUninstallPackages(List<String> packages) async {
    try {
      final jsonEncoded = jsonEncode(packages);
      await _storage.write(
        key: uninstallPackagesStorageKey,
        value: jsonEncoded,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(PreferencesException(error), stackTrace);
    }
  }
}
