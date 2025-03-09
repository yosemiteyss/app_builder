import 'package:app_builder/l10n/l10n.dart';
import 'package:app_builder/utils/utils.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:task_repository/task_repository.dart';

class TaskStateView extends StatelessWidget {
  const TaskStateView({
    required this.state,
    super.key,
  });

  final TaskState state;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return switch (state) {
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
