import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storage/storage.dart';
import 'package:task_repository/src/task.dart';
import 'package:task_repository/src/task_repository.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('TaskRepository', () {
    late Storage storage;
    late TaskRepository taskRepository;

    setUp(() {
      storage = MockStorage();
      taskRepository = TaskRepository(storage: storage);
    });

    group('getTasks', () {
      test('should return empty task list when no stored data', () async {
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => null);

        final result = await taskRepository.getTasks();

        expect(result, <Task>[]);
        verify(
          () => storage.read(key: TaskRepository.tasksStorageKey),
        ).called(1);
      });

      test('should return deserialized task list when valid JSON exists',
          () async {
        final tasks = [
          const Task(
            directory: 'path/to/1',
            state: IdleState(),
          ),
          const Task(
            directory: 'path/to/2',
            state: IdleState(),
            gradleTask: 'assembleDebug',
          ),
        ];
        final tasksJson = jsonEncode(tasks.map((e) => e.toJson()).toList());

        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => tasksJson);

        final result = await taskRepository.getTasks();

        expect(result, equals(tasks));
        verify(
          () => storage.read(key: TaskRepository.tasksStorageKey),
        ).called(1);
      });

      test('should throws TaskException when JSON is invalid', () async {
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => 'invalid-json');

        expect(taskRepository.getTasks(), throwsA(isA<TaskException>()));
        verify(
          () => storage.read(key: TaskRepository.tasksStorageKey),
        ).called(1);
      });
    });

    group('saveTasks', () {
      test('should save tasks successfully', () async {
        final tasks = [
          const Task(
            directory: 'path/to/1',
            state: IdleState(),
          ),
          const Task(
            directory: 'path/to/2',
            state: IdleState(),
            gradleTask: 'assembleDebug',
          ),
        ];
        final tasksJson = jsonEncode(tasks.map((e) => e.toJson()).toList());

        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await taskRepository.saveTasks(tasks);

        verify(
          () => storage.write(
            key: TaskRepository.tasksStorageKey,
            value: tasksJson,
          ),
        ).called(1);
      });

      test('should throws TaskException when storage write fails', () async {
        final tasks = [
          const Task(
            directory: 'path/to/1',
            state: IdleState(),
          ),
          const Task(
            directory: 'path/to/2',
            state: IdleState(),
            gradleTask: 'assembleDebug',
          ),
        ];

        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenThrow(Exception('Storage error'));

        expect(
          taskRepository.saveTasks(tasks),
          throwsA(isA<TaskException>()),
        );

        verify(
          () => storage.write(
            key: TaskRepository.tasksStorageKey,
            value: any(named: 'value'),
          ),
        ).called(1);
      });
    });
  });
}
