import 'package:app_builder/home/home.dart';
import 'package:app_builder/settings/settings.dart';
import 'package:app_builder/task/task.dart';
import 'package:app_builder/tools/tools.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _taskShellNavKey = GlobalKey<NavigatorState>();
final _preferencesShellNavKey = GlobalKey<NavigatorState>();
final _toolsShellNavKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: TaskView.path,
  navigatorKey: rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          navigatorKey: _taskShellNavKey,
          routes: [
            GoRoute(
              path: TaskView.path,
              builder: (context, state) {
                return const TaskView();
              },
            ),
            GoRoute(
              path: LogsView.path,
              builder: (context, state) {
                return LogsView.fromPathParams(
                  pathParameters: state.pathParameters,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _preferencesShellNavKey,
          routes: [
            GoRoute(
              path: SettingsView.path,
              builder: (context, state) {
                return const SettingsView();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _toolsShellNavKey,
          routes: [
            GoRoute(
              path: ToolsView.path,
              builder: (context, state) {
                return const ToolsView();
              },
            ),
          ],
        ),
      ],
      builder: (context, state, child) {
        return HomeView(child: child);
      },
    ),
  ],
);
