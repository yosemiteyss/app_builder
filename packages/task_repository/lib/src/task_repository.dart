import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:storage/storage.dart';
import 'package:task_repository/task_repository.dart';

/// {@template task_exception}
/// Exception class for task failures.
/// {@endtemplate}
class TaskException with EquatableMixin implements Exception {
  /// {@macro task_exception}
  const TaskException(this.error);

  /// The error caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template task_repository}
/// Repository for managing build tasks.
/// {@endtemplate}
class TaskRepository {
  /// {@macro task_repository}
  const TaskRepository({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  /// Storage key for tasks.
  static const String tasksStorageKey = 'tasks';

  /// Get task list.
  Future<List<Task>> getTasks() async {
    try {
      final jsonString = await _storage.read(key: tasksStorageKey);
      if (jsonString == null) {
        return const [];
      }

      final jsonDecoded = jsonDecode(jsonString) as List<dynamic>;
      return List<Task>.from(
        jsonDecoded.map((e) => Task.fromJson(e as Map<String, dynamic>)),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(TaskException(error), stackTrace);
    }
  }

  /// Save task list.
  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final jsonEncoded = jsonEncode(tasks.map((e) => e.toJson()).toList());
      await _storage.write(key: tasksStorageKey, value: jsonEncoded);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(TaskException(error), stackTrace);
    }
  }
}
