class InvalidGitDirException implements Exception {
  const InvalidGitDirException(this.directory);

  final String directory;

  @override
  String toString() => 'InvalidGitDirException: $directory';
}
