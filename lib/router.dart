import 'package:app_builder/module/home.dart';
import 'package:app_builder/module/settings/settings_page.dart';
import 'package:app_builder/module/task/ui/logs_page.dart';
import 'package:app_builder/module/task/ui/task_page.dart';
import 'package:app_builder/module/tools/ui/tools_page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _taskShellNavKey = GlobalKey<NavigatorState>();
final _envShellNavKey = GlobalKey<NavigatorState>();
final _toolsShellNavKey = GlobalKey<NavigatorState>();

final appBuilderRouter = GoRouter(
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
                return const TaskPage();
              },
            ),
            GoRoute(
              path: '/logs/:directory',
              builder: (context, state) {
                final directory =
                    Uri.decodeComponent(state.pathParameters['directory']!);
                return LogsPage(directory: directory);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _envShellNavKey,
          routes: [
            GoRoute(
              path: '/config',
              builder: (context, state) {
                return const SettingsPage();
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
                return const ToolsPage();
              },
            ),
          ],
        ),
      ],
      builder: (context, state, child) {
        return Home(child: child);
      },
    ),
  ],
);
