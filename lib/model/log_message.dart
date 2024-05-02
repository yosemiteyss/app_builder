enum LogLevel { stdout, stderr }

class LogMessage {
  const LogMessage({
    required this.taskDir,
    required this.message,
    required this.level,
  });

  final String taskDir;
  final String message;
  final LogLevel level;
}
