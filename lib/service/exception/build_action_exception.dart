class BuildActionException implements Exception {
  const BuildActionException(this.directory, this.message);

  final String directory;
  final String message;

  @override
  String toString() => 'BuildActionException: $message ($directory)';
}
