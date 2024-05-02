class InvalidParamException implements Exception {
  const InvalidParamException(this.parameter);

  final String parameter;

  @override
  String toString() => 'InvalidParameterException: $parameter';
}
