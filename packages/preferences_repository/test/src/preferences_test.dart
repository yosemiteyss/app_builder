import 'package:preferences_repository/src/preferences.dart';
import 'package:test/test.dart';

void main() {
  group('Preferences', () {
    test('should supports value comparison', () {
      expect(
        const Preferences(javaHome: '/path/to/java'),
        const Preferences(javaHome: '/path/to/java'),
      );
    });

    group('fromJson', () {
      test('should creates a valid instance', () {
        final json = {
          'java_home': '/path/to/java',
          'android_home': '/path/to/android',
          'gradle_task': 'assembleDebug',
          'stash_changes': false,
          'install_build': true,
        };
        final preferences = Preferences.fromJson(json);

        expect(preferences.javaHome, '/path/to/java');
        expect(preferences.androidHome, '/path/to/android');
        expect(preferences.gradleTask, 'assembleDebug');
        expect(preferences.isStashChanges, false);
        expect(preferences.isInstallBuild, true);
      });
    });

    group('toJson', () {
      test('should returns correct map', () {
        const preferences = Preferences(
          javaHome: '/path/to/java',
          androidHome: '/path/to/android',
          gradleTask: 'assembleDebug',
          isStashChanges: false,
        );

        expect(preferences.toJson(), {
          'java_home': '/path/to/java',
          'android_home': '/path/to/android',
          'gradle_task': 'assembleDebug',
          'stash_changes': false,
          'install_build': true,
        });
      });
    });

    group('copyWith', () {
      test('should creates a new instance with updated values', () {
        const preferences = Preferences(
          javaHome: '/path/to/java',
          androidHome: '/path/to/android',
        );

        final updatedConfig =
            preferences.copyWith(androidHome: '/new/path/to/android');

        expect(updatedConfig.javaHome, '/path/to/java');
        expect(updatedConfig.androidHome, '/new/path/to/android');
      });
    });
  });
}
