import 'package:equatable/equatable.dart';

/// {@template invalid_directory_exception}
/// Exception class for invalid task directory.
/// {@endtemplate}
class InvalidDirectoryException extends Equatable implements Exception {
  /// {@macro invalid_directory_exception}
  const InvalidDirectoryException(this.directory);

  /// The task directory.
  final String directory;

  @override
  String toString() => 'InvalidDirectoryException: $directory';

  @override
  List<Object?> get props => [directory];
}
