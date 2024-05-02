import 'package:app_builder/ui/config_page.dart';
import 'package:app_builder/ui/home.dart';
import 'package:app_builder/ui/log_page.dart';
import 'package:app_builder/ui/task_page.dart';
import 'package:app_builder/ui/tools_page.dart';
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
                return LogPage(directory: directory);
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
                return const ConfigPage();
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
