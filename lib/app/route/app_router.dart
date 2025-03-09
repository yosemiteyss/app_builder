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
  initialLocation: '/tasks',
  navigatorKey: rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          navigatorKey: _taskShellNavKey,
          routes: [
            GoRoute(
              path: '/tasks',
              builder: (context, state) {
                return const TaskView();
              },
            ),
            GoRoute(
              path: '/logs/:directory',
              builder: (context, state) {
                final directory =
                    Uri.decodeComponent(state.pathParameters['directory']!);
                return LogsView(directory: directory);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _preferencesShellNavKey,
          routes: [
            GoRoute(
              path: '/config',
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
              path: '/tools',
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
