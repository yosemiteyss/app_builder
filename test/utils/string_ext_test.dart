import 'package:app_builder/utils/string_ext.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtension', () {
    group('isBlank', () {
      test('isBlank should return true for an empty string', () {
        expect(''.isBlank, isTrue);
      });

      test('isBlank should return true for a string with only whitespace', () {
        expect('   '.isBlank, isTrue);
      });

      test('isBlank should return false for a non-empty string', () {
        expect('hello'.isBlank, isFalse);
      });
    });

    group('isNotBlank', () {
      test('isNotBlank should return false for an empty string', () {
        expect(''.isNotBlank, isFalse);
      });

      test('isNotBlank should return false for a string with only whitespace',
          () {
        expect('   '.isNotBlank, isFalse);
      });

      test('isNotBlank should return true for a non-empty string', () {
        expect('hello'.isNotBlank, isTrue);
      });
    });
  });
}
