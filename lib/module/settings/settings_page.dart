import 'package:app_builder/main.dart';
import 'package:app_builder/module/common/model/config.dart';
import 'package:app_builder/module/settings/settings_bloc.dart';
import 'package:app_builder/module/settings/settings_event.dart';
import 'package:app_builder/module/task/bloc/task_list_bloc.dart';
import 'package:app_builder/module/task/model/task_list_state.dart';
import 'package:app_builder/utils/build_context_ext.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _gradleTaskController = TextEditingController();

  @override
  void dispose() {
    _gradleTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return BlocProvider(
      create: (context) => SettingsBloc(getIt())..add(OnSettingsInit()),
      child: BlocConsumer<SettingsBloc, Config>(
        listenWhen: (previous, current) {
          return previous.gradleTask == null && current.gradleTask != null;
        },
        listener: (context, state) {
          final gradleTask = state.gradleTask;
          if (gradleTask != null) {
            _gradleTaskController.text = gradleTask;
          }
        },
        builder: (context, config) {
          return ScaffoldPage.scrollable(
            header: PageHeader(
              title: Text(context.l10n.settingsPageTitle),
            ),
            children: [
              // JAVA_HOME
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                        'JAVA_HOME',
                        style: theme.typography.bodyStrong,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(config.javaHome ?? ''),
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
                                      .read<SettingsBloc>()
                                      .add(OnUpdateJavaHome());
                                },
                          child: Text(context.l10n.editAction),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // ANDROID_HOME
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                        'ANDROID_HOME',
                        style: theme.typography.bodyStrong,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(config.androidHome ?? ''),
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
                                      .read<SettingsBloc>()
                                      .add(OnUpdateAndroidHome());
                                },
                          child: Text(context.l10n.editAction),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // Gradle Task
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.gradleTask,
                            style: theme.typography.bodyStrong,
                          ),
                          Text(
                            context.l10n.gradleTaskDesc,
                            style: theme.typography.caption?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
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
                              context
                                  .read<SettingsBloc>()
                                  .add(OnUpdateGradleTask(value));
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // Stash
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.stashChanges,
                            style: theme.typography.bodyStrong,
                          ),
                          Text(
                            context.l10n.stashChangesDesc,
                            style: theme.typography.caption?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocSelector<TaskListBloc, TaskListState, bool>(
                      selector: (state) => state.isTaskOngoing,
                      builder: (context, state) {
                        return Checkbox(
                          checked: config.isStashChanges,
                          onChanged: state
                              ? null
                              : (value) {
                                  context
                                      .read<SettingsBloc>()
                                      .add(OnUpdateStashChanges(value ?? false));
                                },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // Install
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.installBuild,
                            style: theme.typography.bodyStrong,
                          ),
                          Text(
                            context.l10n.installBuildDesc,
                            style: theme.typography.caption?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocSelector<TaskListBloc, TaskListState, bool>(
                      selector: (state) => state.isTaskOngoing,
                      builder: (context, state) {
                        return Checkbox(
                          checked: config.isInstallBuild,
                          onChanged: state
                              ? null
                              : (value) {
                                  context
                                      .read<SettingsBloc>()
                                      .add(OnUpdateInstallBuild(value ?? false));
                                },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
