import 'package:app_builder/utils/build_context_ext.dart';
import 'package:app_builder/utils/duration_ext.dart';
import 'package:fluent_ui/fluent_ui.dart';

sealed class TaskState {
  TaskState();

  factory TaskState.idle() => IdleState();

  factory TaskState.success(Duration? elapsed) => SuccessState(elapsed);

  factory TaskState.ongoing(String? action) => OngoingState(action);

  factory TaskState.error(Exception? e) => ErrorState(e);

  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return switch (this) {
      IdleState() => const SizedBox.shrink(),
      SuccessState(:final elapsed) => Row(
          children: [
            const Icon(
              FluentIcons.accept,
              color: Colors.successPrimaryColor,
            ),
            if (elapsed != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  context.l10n.elapsedTime(elapsed.toMinutesSeconds()),
                  style: theme.typography.caption?.copyWith(
                    color: Colors.successPrimaryColor,
                  ),
                ),
              ),
          ],
        ),
      ErrorState() => const Icon(
          FluentIcons.error,
          color: Colors.errorPrimaryColor,
        ),
      OngoingState() => const SizedBox.square(
          dimension: 24,
          child: ProgressRing(),
        ),
    };
  }
}

class IdleState extends TaskState {
  @override
  String toString() => 'IdleState';
}

class SuccessState extends TaskState {
  SuccessState(this.elapsed);

  final Duration? elapsed;

  @override
  String toString() => 'SuccessState';
}

class OngoingState extends TaskState {
  OngoingState(this.action);

  final String? action;

  @override
  String toString() => 'OngoingState: $action';
}

class ErrorState extends TaskState {
  ErrorState(this.e);

  final Exception? e;

  @override
  String toString() => 'ErrorState: $e';
}
