import 'package:app_builder/l10n/l10n.dart';
import 'package:app_builder/settings/settings.dart';
import 'package:app_builder/task/task.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences_repository/preferences_repository.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
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
      create: (context) => SettingsBloc(
        preferencesRepository: context.read<PreferencesRepository>(),
      ),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) {
          return previous.preferences.gradleTask == null &&
              current.preferences.gradleTask != null;
        },
        listener: (context, state) {
          final gradleTask = state.preferences.gradleTask;
          if (gradleTask != null) {
            _gradleTaskController.text = gradleTask;
          }
        },
        builder: (context, settings) {
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
                        child: Text(settings.preferences.javaHome ?? ''),
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
                                      .add(const OnUpdateJavaHome());
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
                        child: Text(settings.preferences.androidHome ?? ''),
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
                                      .add(const OnUpdateAndroidHome());
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
                          checked: settings.preferences.isStashChanges,
                          onChanged: state
                              ? null
                              : (value) {
                                  context.read<SettingsBloc>().add(
                                        OnUpdateStashChanges(
                                          isStashChanges: value ?? false,
                                        ),
                                      );
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
                          checked: settings.preferences.isInstallBuild,
                          onChanged: state
                              ? null
                              : (value) {
                                  context.read<SettingsBloc>().add(
                                        OnUpdateInstallBuild(
                                          isInstallBuild: value ?? false,
                                        ),
                                      );
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
