import 'package:app_builder/main.dart';
import 'package:app_builder/model/config.dart';
import 'package:app_builder/model/task_list_state.dart';
import 'package:app_builder/provider/config_bloc.dart';
import 'package:app_builder/provider/config_event.dart';
import 'package:app_builder/provider/task_list_bloc.dart';
import 'package:app_builder/utils/build_context_ext.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
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
      create: (context) => ConfigBloc(getIt())..add(OnConfigInit()),
      child: BlocConsumer<ConfigBloc, Config>(
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
              title: Text(context.l10n.configPageTitle),
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
                                      .read<ConfigBloc>()
                                      .add(OnSetJavaHome());
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
                                      .read<ConfigBloc>()
                                      .add(OnSetAndroidHome());
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
                                  .read<ConfigBloc>()
                                  .add(OnSetGradleTask(value));
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
                          checked: config.stashChanges,
                          onChanged: state
                              ? null
                              : (value) {
                                  context
                                      .read<ConfigBloc>()
                                      .add(OnSetStashChanges(value ?? false));
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
                          checked: config.installBuild,
                          onChanged: state
                              ? null
                              : (value) {
                                  context
                                      .read<ConfigBloc>()
                                      .add(OnSetInstallBuild(value ?? false));
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
