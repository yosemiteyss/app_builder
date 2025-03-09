import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:storage/storage.dart';
import 'package:test/test.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('PreferencesRepository', () {
    late Storage storage;
    late PreferencesRepository preferencesRepository;

    setUp(() {
      storage = MockStorage();
      preferencesRepository = PreferencesRepository(storage: storage);
      //registerFallbackValue(FakePreferences());
    });

    group('getPreferences', () {
      test('should returns default Preferences when no stored data', () async {
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => null);

        final result = await preferencesRepository.getPreferences();

        expect(result, equals(const Preferences()));
        verify(
          () => storage.read(key: PreferencesRepository.preferencesStorageKey),
        ).called(1);
      });

      test('should returns deserialized Preferences when valid JSON exists',
          () async {
        final preferencesJson =
            jsonEncode(const Preferences(javaHome: 'dir').toJson());
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => preferencesJson);

        final result = await preferencesRepository.getPreferences();

        expect(result, isA<Preferences>());
        expect(result.javaHome, 'dir');

        verify(
          () => storage.read(key: PreferencesRepository.preferencesStorageKey),
        ).called(1);
      });

      test('should throws PreferencesException when JSON is invalid', () async {
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => 'invalid-json');

        expect(
          preferencesRepository.getPreferences(),
          throwsA(isA<PreferencesException>()),
        );

        verify(
          () => storage.read(key: PreferencesRepository.preferencesStorageKey),
        ).called(1);
      });
    });

    group('savePreferences', () {
      test('should saves preferences successfully', () async {
        const preferences = Preferences();
        final jsonEncoded = jsonEncode(preferences.toJson());

        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await preferencesRepository.savePreferences(preferences);

        verify(
          () => storage.write(
            key: PreferencesRepository.preferencesStorageKey,
            value: jsonEncoded,
          ),
        ).called(1);
      });

      test('should throws PreferencesException when storage write fails',
          () async {
        const preferences = Preferences();
        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenThrow(Exception('Storage error'));

        expect(
          preferencesRepository.savePreferences(preferences),
          throwsA(isA<PreferencesException>()),
        );

        verify(
          () => storage.write(
            key: PreferencesRepository.preferencesStorageKey,
            value: any(named: 'value'),
          ),
        ).called(1);
      });
    });

    group('getUninstallPackages', () {
      test('should returns an empty list when no packages are stored',
          () async {
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => null);

        final result = await preferencesRepository.getUninstallPackages();

        expect(result, isEmpty);
        verify(
          () => storage.read(
            key: PreferencesRepository.uninstallPackagesStorageKey,
          ),
        ).called(1);
      });

      test('returns a list of packages when stored data exists', () async {
        final packagesJson = jsonEncode(
          ['com.example.app1', 'com.example.app2'],
        );
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => packagesJson);

        final result = await preferencesRepository.getUninstallPackages();

        expect(result, equals(['com.example.app1', 'com.example.app2']));
        verify(
          () => storage.read(
            key: PreferencesRepository.uninstallPackagesStorageKey,
          ),
        ).called(1);
      });

      test('should throws PreferencesException when storage read fails',
          () async {
        when(() => storage.read(key: any(named: 'key')))
            .thenThrow(Exception('Storage read error'));

        expect(
          preferencesRepository.getUninstallPackages(),
          throwsA(isA<PreferencesException>()),
        );

        verify(
          () => storage.read(
            key: PreferencesRepository.uninstallPackagesStorageKey,
          ),
        ).called(1);
      });
    });

    group('saveUninstallPackages', () {
      test('saves uninstall packages successfully', () async {
        final packages = ['com.example.app1', 'com.example.app2'];
        final jsonEncoded = jsonEncode(packages);

        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await preferencesRepository.saveUninstallPackages(packages);

        verify(
          () => storage.write(
            key: PreferencesRepository.uninstallPackagesStorageKey,
            value: jsonEncoded,
          ),
        ).called(1);
      });

      test('should throws PreferencesException when storage write fails',
          () async {
        final packages = ['com.example.app1', 'com.example.app2'];
        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenThrow(Exception('Storage write error'));

        expect(
          preferencesRepository.saveUninstallPackages(packages),
          throwsA(isA<PreferencesException>()),
        );

        verify(
          () => storage.write(
            key: PreferencesRepository.uninstallPackagesStorageKey,
            value: any(named: 'value'),
          ),
        ).called(1);
      });
    });
  });
}
