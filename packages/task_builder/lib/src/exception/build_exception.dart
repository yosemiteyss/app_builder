import 'package:equatable/equatable.dart';

/// {@template build_exception}
/// Exception class for build failures.
/// {@endtemplate}
class BuildException extends Equatable implements Exception {
  /// {@macro build_exception}
  const BuildException({
    required this.directory,
    required this.message,
  });

  /// The task directory.
  final String directory;

  /// The error message.
  final String message;

  @override
  String toString() => 'BuildException: $message ($directory)';

  @override
  List<Object?> get props => [directory, message];
}
