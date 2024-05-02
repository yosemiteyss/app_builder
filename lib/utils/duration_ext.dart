extension DurationFormatting on Duration {
  String toMinutesSeconds() {
    final int minutes = inMinutes;
    final int seconds = inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
