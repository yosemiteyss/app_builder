import 'package:flutter_test/flutter_test.dart';
import 'package:task_repository/task_repository.dart';

void main() {
  group('Task', () {
    test('should supports value comparison', () {
      expect(
        const Task(
          directory: 'task_dir',
          state: IdleState(),
        ),
        const Task(
          directory: 'task_dir',
          state: IdleState(),
        ),
      );
    });

    group('fromJson', () {
      test('should creates a valid instance', () {
        final json = {
          'directory': 'path/to',
          'gradle_task': 'assembleDebug',
          'output_dir': 'build/outputs',
          'selected_branch': 'main',
          'is_exclude_from_build_all': true,
        };
        final preferences = Task.fromJson(json);

        expect(preferences.directory, 'path/to');
        expect(preferences.gradleTask, 'assembleDebug');
        expect(preferences.outputDir, 'build/outputs');
        expect(preferences.selectedBranch, 'main');
        expect(preferences.isExcludeFromBuildAll, true);
      });
    });

    group('toJson', () {
      test('should returns correct map', () {
        const task = Task(
          directory: 'path/to',
          state: IdleState(),
          gradleTask: 'assembleDebug',
          outputDir: 'build/outputs',
          selectedBranch: 'main',
          isExcludeFromBuildAll: true,
        );

        expect(task.toJson(), {
          'directory': 'path/to',
          'gradle_task': 'assembleDebug',
          'output_dir': 'build/outputs',
          'selected_branch': 'main',
          'is_exclude_from_build_all': true,
        });
      });
    });

    group('copyWith', () {
      test('should creates a new instance with updated values', () {
        const task = Task(
          directory: 'path/to',
          state: IdleState(),
        );

        final updatedTask =
            task.copyWith(state: const OngoingState('building'));

        expect(updatedTask.directory, 'path/to');
        expect(updatedTask.state, const OngoingState('building'));
      });
    });
  });
}
