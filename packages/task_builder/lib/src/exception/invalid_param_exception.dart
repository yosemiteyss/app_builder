import 'package:equatable/equatable.dart';

/// {@template invalid_param_exception}
/// Exception class for invalid parameter.
/// {@endtemplate}
class InvalidParamException extends Equatable implements Exception {
  /// {@macro invalid_param_exception}
  const InvalidParamException(this.parameter);

  /// The parameter.
  final String parameter;

  @override
  String toString() => 'InvalidParameterException: $parameter';

  @override
  List<Object?> get props => [parameter];
}
