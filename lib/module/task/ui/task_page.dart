import 'package:app_builder/module/common/model/task.dart';
import 'package:app_builder/module/common/widget/toast.dart';
import 'package:app_builder/module/task/bloc/task_list_bloc.dart';
import 'package:app_builder/module/task/bloc/task_list_event.dart';
import 'package:app_builder/module/task/model/task_list_state.dart';
import 'package:app_builder/module/task/model/task_state.dart';
import 'package:app_builder/router.dart';
import 'package:app_builder/utils/build_context_ext.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskListBloc>().add(OnLoadTasks());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskListBloc, TaskListState>(
      listenWhen: (previous, current) {
        return current.taskException != null &&
            previous.taskException != current.taskException;
      },
      listener: (context, state) {
        Toast.show(context: context, message: state.taskException.toString());
      },
      builder: (context, state) {
        return ScaffoldPage(
          header: PageHeader(
            title: Text(context.l10n.taskPageTitle),
          ),
          content: CustomScrollView(
            slivers: [
              // Add Task
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8, right: 16),
                          child: Icon(FluentIcons.add_to),
                        ),
                        Expanded(
                          child: Text(context.l10n.addTask),
                        ),
                        BlocSelector<TaskListBloc, TaskListState, bool>(
                          selector: (state) => state.allowTaskAdd,
                          builder: (context, state) {
                            return ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 60),
                              child: FilledButton(
                                onPressed: !state
                                    ? null
                                    : () {
                                        context
                                            .read<TaskListBloc>()
                                            .add(OnAddTask());
                                      },
                                child: Text(context.l10n.openAction),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Build all task
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8, right: 16),
                          child: Icon(FluentIcons.task_list),
                        ),
                        Expanded(
                          child: Text(context.l10n.buildAll),
                        ),
                        BlocSelector<TaskListBloc, TaskListState, bool>(
                          selector: (state) => state.isTaskOngoing,
                          builder: (context, state) {
                            return ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 60),
                              child: FilledButton(
                                onPressed: state
                                    ? null
                                    : () {
                                        context
                                            .read<TaskListBloc>()
                                            .add(OnBuildTaskList());
                                      },
                                child: Text(context.l10n.startAction),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Task list
              BlocSelector<TaskListBloc, TaskListState, List<Task>>(
                selector: (state) => state.taskListSorted,
                builder: (context, state) {
                  return SliverPadding(
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    sliver: SliverList.separated(
                      itemCount: state.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },
                      itemBuilder: (context, index) {
                        return _TaskRow(
                          key: ValueKey(state[index].directory),
                          task: state[index],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TaskRow extends StatefulWidget {
  const _TaskRow({super.key, required this.task});

  final Task task;

  @override
  State<_TaskRow> createState() => _TaskRowState();
}

class _TaskRowState extends State<_TaskRow> {
  final TextEditingController _gradleTaskController = TextEditingController();
  final FlyoutController _flyoutController = FlyoutController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gradleTask = widget.task.gradleTask;
      if (gradleTask != null) {
        _gradleTaskController.text = gradleTask;
      }
    });
  }

  @override
  void dispose() {
    _gradleTaskController.dispose();
    _flyoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final taskState = widget.task.state;

    return Expander(
      initiallyExpanded: widget.task.isExpanded,
      onStateChanged: (expanded) {
        context.read<TaskListBloc>().add(
              OnUpdateTask(widget.task.copyWith(isExpanded: expanded)),
            );
      },
      header: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 120),
              child: Text(
                widget.task.name,
                style: theme.typography.bodyStrong,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(widget.task.directory),
              ),
            ),
            // Task state icon.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: taskState.build(context),
            ),
            // Task state message.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: switch (taskState) {
                OngoingState(:final action) => Text(
                    '${action ?? context.l10n.waiting}...',
                    style: theme.typography.caption,
                  ),
                _ => const SizedBox.shrink(),
              },
            ),
            // Stop button
            if (taskState is OngoingState)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                  icon: const Icon(FluentIcons.stop),
                  onPressed: () {
                    context.read<TaskListBloc>().add(OnStopTask(widget.task));
                  },
                ),
              ),
            // More actions menu
            FlyoutTarget(
              controller: _flyoutController,
              child: IconButton(
                icon: const Icon(FluentIcons.more),
                onPressed: () {
                  _flyoutController.showFlyout<void>(
                    navigatorKey: rootNavigatorKey.currentState,
                    builder: (_) {
                      return MenuFlyout(
                        items: [
                          if (taskState is! OngoingState)
                            MenuFlyoutItem(
                              text: Text(context.l10n.buildAction),
                              onPressed: () {
                                context
                                    .read<TaskListBloc>()
                                    .add(OnBuildTask(widget.task));
                              },
                            ),
                          MenuFlyoutItem(
                            text: Text(context.l10n.logPageTitle),
                            onPressed: () {
                              context.push(
                                '/logs/${Uri.encodeComponent(widget.task.directory)}',
                              );
                            },
                          ),
                          if (taskState is! OngoingState)
                            MenuFlyoutItem(
                              text: Text(context.l10n.removeAction),
                              onPressed: () {
                                context
                                    .read<TaskListBloc>()
                                    .add(OnRemoveTask(widget.task));
                              },
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  context.l10n.branch,
                  style: theme.typography.bodyStrong,
                ),
              ),
              if (widget.task.branches.isNotEmpty)
                BlocSelector<TaskListBloc, TaskListState, bool>(
                  selector: (state) => state.isTaskOngoing,
                  builder: (context, state) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(FluentIcons.refresh),
                          onPressed: state
                              ? null
                              : () {
                                  context
                                      .read<TaskListBloc>()
                                      .add(OnRefreshTaskBranch(widget.task));
                                },
                        ),
                        const SizedBox(width: 8),
                        DropDownButton(
                          disabled: state,
                          title: Text(
                            widget.task.selectedBranch ??
                                context.l10n.selectAction,
                          ),
                          items: widget.task.branches.map((branch) {
                            return MenuFlyoutItem(
                              text: Text(branch),
                              onPressed: () {
                                context.read<TaskListBloc>().add(OnUpdateTask(
                                    widget.task
                                        .copyWith(selectedBranch: branch)));
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Gradle task
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  context.l10n.gradleTask,
                  style: theme.typography.bodyStrong,
                ),
              ),
              BlocSelector<TaskListBloc, TaskListState, bool>(
                selector: (state) => state.isTaskOngoing,
                builder: (context, state) {
                  return SizedBox(
                    width: 140,
                    child: TextBox(
                      controller: _gradleTaskController,
                      enabled: !state,
                      onChanged: (value) {
                        context.read<TaskListBloc>().add(OnUpdateTask(
                            widget.task.copyWith(gradleTask: value)));
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Output directory
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  context.l10n.outputFolder,
                  style: theme.typography.bodyStrong,
                ),
              ),
              if (widget.task.outputDir != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(widget.task.outputDir!),
                  ),
                ),
              BlocSelector<TaskListBloc, TaskListState, bool>(
                selector: (state) => state.isTaskOngoing,
                builder: (context, state) {
                  return Button(
                    onPressed: state
                        ? null
                        : () {
                            context
                                .read<TaskListBloc>()
                                .add(OnUpdateTaskOutputDir(widget.task));
                          },
                    child: Text(context.l10n.editAction),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Exclude from build all
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  context.l10n.excludeFromBuildAll,
                  style: theme.typography.bodyStrong,
                ),
              ),
              BlocSelector<TaskListBloc, TaskListState, bool>(
                selector: (state) => state.isTaskOngoing,
                builder: (context, state) {
                  return Checkbox(
                    checked: widget.task.isExcludeFromBuildAll ?? false,
                    onChanged: state
                        ? null
                        : (value) {
                            context.read<TaskListBloc>().add(
                                  OnUpdateTask(widget.task
                                      .copyWith(isExcludeFromBuildAll: value)),
                                );
                          },
                  );
                },
              ),
            ],
          ),
          if (taskState is ErrorState) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  FluentIcons.error,
                  color: Colors.errorPrimaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    taskState.e.toString(),
                    style: theme.typography.body?.copyWith(
                      color: Colors.errorPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
