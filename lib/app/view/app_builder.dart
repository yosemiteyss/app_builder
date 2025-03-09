import 'package:app_builder/app/app.dart';
import 'package:app_builder/l10n/l10n.dart';
import 'package:app_builder/task/bloc/task_list_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:system_theme/system_theme.dart';
import 'package:task_builder/task_builder.dart';
import 'package:task_repository/task_repository.dart';

class App extends StatelessWidget {
  const App({
    required this.taskRepository,
    required this.preferencesRepository,
    required this.taskBuilderService,
    super.key,
  });

  final TaskRepository taskRepository;
  final PreferencesRepository preferencesRepository;
  final TaskBuilderService taskBuilderService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: taskRepository),
        RepositoryProvider.value(value: preferencesRepository),
        RepositoryProvider.value(value: taskBuilderService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => TaskListBloc(
              preferenceRepository: preferencesRepository,
              taskRepository: taskRepository,
              taskBuilderService: taskBuilderService,
            )..add(const OnLoadTasks()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  static final accentColor = AccentColor.swatch({
    'darkest': SystemTheme.accentColor.darkest,
    'darker': SystemTheme.accentColor.darker,
    'dark': SystemTheme.accentColor.dark,
    'normal': SystemTheme.accentColor.accent,
    'light': SystemTheme.accentColor.light,
    'lighter': SystemTheme.accentColor.lighter,
    'lightest': SystemTheme.accentColor.lightest,
  });

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      title: 'App Builder',
      color: accentColor,
      debugShowCheckedModeBanner: false,
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: accentColor,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      theme: FluentThemeData(
        accentColor: accentColor,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      routerConfig: appRouter,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
