extension StringExtension on String {
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;
}
