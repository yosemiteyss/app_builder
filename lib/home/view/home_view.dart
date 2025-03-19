import 'package:app_builder/l10n/l10n.dart';
import 'package:app_builder/settings/settings.dart';
import 'package:app_builder/task/task.dart';
import 'package:app_builder/tools/tools.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WindowListener {
  late final List<NavigationPaneItem> _paneItems = [
    PaneItem(
      key: const ValueKey(TaskView.path),
      icon: const Icon(FluentIcons.task_add),
      title: Text(context.l10n.taskPageTitle),
      body: const SizedBox.shrink(),
    ),
    PaneItem(
      key: const ValueKey(SettingsView.path),
      icon: const Icon(FluentIcons.parameter),
      title: Text(context.l10n.settingsPageTitle),
      body: const SizedBox.shrink(),
    ),
    PaneItem(
      key: const ValueKey(ToolsView.path),
      icon: const Icon(FluentIcons.toolbox),
      title: Text(context.l10n.toolsPageTitle),
      body: const SizedBox.shrink(),
    ),
  ].map<NavigationPaneItem>((e) {
    PaneItem buildPaneItem(PaneItem item) {
      return PaneItem(
        key: item.key,
        icon: item.icon,
        title: item.title,
        body: item.body,
        onTap: () {
          final path = (item.key! as ValueKey).value as String;
          if (GoRouterState.of(context).uri.toString() != path) {
            context.go(path);
          }
          item.onTap?.call();
        },
      );
    }

    if (e is PaneItemExpander) {
      return PaneItemExpander(
        key: e.key,
        icon: e.icon,
        title: e.title,
        body: e.body,
        items: e.items.map((item) {
          if (item is PaneItem) {
            return buildPaneItem(item);
          }
          return item;
        }).toList(),
      );
    }

    return buildPaneItem(e);
  }).toList();

  int _prevSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final router = GoRouter.of(context);

    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        leading: () {
          final enabled = _isPopEnabled(context);
          void onPressed() {
            if (router.canPop()) {
              context.pop();
            }
          }

          return NavigationPaneTheme(
            data: NavigationPaneTheme.of(context).merge(
              NavigationPaneThemeData(
                unselectedIconColor: WidgetStateProperty.resolveWith((states) {
                  if (states.isDisabled) {
                    return ButtonThemeData.buttonColor(context, states);
                  }
                  return ButtonThemeData.uncheckedInputColor(
                    theme,
                    states,
                  ).basedOnLuminance();
                }),
              ),
            ),
            child: Builder(
              builder: (context) => PaneItem(
                icon: const Center(child: Icon(FluentIcons.back, size: 12)),
                title: Text(context.l10n.backAction),
                body: const SizedBox.shrink(),
                enabled: enabled,
              ).build(
                context,
                false,
                onPressed,
                displayMode: PaneDisplayMode.compact,
              ),
            ),
          );
        }(),
        title: () {
          if (UniversalPlatform.isWeb) {
            return Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(context.l10n.appName),
            );
          }
          return DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(context.l10n.appName),
            ),
          );
        }(),
        actions: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!UniversalPlatform.isWeb) const WindowButtons(),
          ],
        ),
      ),
      paneBodyBuilder: (item, child) {
        final name = (item!.key! as ValueKey).value;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },
      pane: NavigationPane(
        selected: _calculateSelectedIndex(context, _paneItems),
        items: _paneItems,
      ),
    );
  }

  @override
  Future<void> onWindowClose() async {
    final isPreventClose = await windowManager.isPreventClose();
    if (!isPreventClose) return;
    if (!mounted) return;

    final result = await _showConfirmExitDialog();
    if (result == null || !result) return;

    await windowManager.setPreventClose(false);
    await windowManager.close();
  }

  Future<bool?> _showConfirmExitDialog() {
    return showDialog(
      context: context,
      builder: (_) {
        return ContentDialog(
          title: Text(context.l10n.confirmCloseTitle),
          content: Text(context.l10n.confirmCloseDesc),
          actions: [
            FilledButton(
              child: Text(context.l10n.yes),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            Button(
              child: Text(context.l10n.no),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  int _calculateSelectedIndex(
    BuildContext context,
    List<NavigationPaneItem> paneItems,
  ) {
    final location = GoRouterState.of(context).uri.toString();
    final indexOriginal = paneItems
        .where((item) => item.key != null)
        .toList()
        .indexWhere((item) => item.key == Key(location));

    if (indexOriginal == -1) {
      return _prevSelectedIndex;
    }

    _prevSelectedIndex = indexOriginal;
    return indexOriginal;
  }

  bool _isPopEnabled(BuildContext context) {
    return GoRouterState.of(context).uri.toString().startsWith('/logs') == true;
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
