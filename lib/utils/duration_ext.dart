extension DurationFormatting on Duration {
  String toMinutesSeconds() {
    final minutes = inMinutes;
    final seconds = inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
