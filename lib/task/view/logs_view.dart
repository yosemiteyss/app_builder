import 'package:app_builder/l10n/l10n.dart';
import 'package:app_builder/task/task.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_builder/task_builder.dart';

class LogsView extends StatefulWidget {
  const LogsView({required this.directory, super.key});

  final String directory;

  @override
  State<StatefulWidget> createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return BlocProvider.value(
      value: BlocProvider.of<TaskListBloc>(context),
      child: ScaffoldPage.withPadding(
        header: PageHeader(
          title: Text(context.l10n.logPageTitle),
        ),
        content: Card(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Scrollbar(
            controller: _scrollController,
            child: SelectionArea(
              child: BlocConsumer<TaskListBloc, TaskListState>(
                listenWhen: (previous, current) {
                  return previous.tasksLogs[widget.directory] !=
                      current.tasksLogs[widget.directory];
                },
                listener: (context, state) {
                  _scrollToBottom();
                },
                buildWhen: (previous, current) {
                  return previous.tasksLogs[widget.directory] !=
                      current.tasksLogs[widget.directory];
                },
                builder: (context, state) {
                  final messages = state.tasksLogs[widget.directory] ?? [];
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return switch (messages[index].level) {
                        LogLevel.stdout => Text(
                            messages[index].message,
                            style: theme.typography.caption,
                          ),
                        LogLevel.stderr => Text(
                            messages[index].message,
                            style: theme.typography.caption
                                ?.copyWith(color: Colors.red),
                          )
                      };
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
