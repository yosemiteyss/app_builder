import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_theme/system_theme.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

/// Place external dependencies here.
typedef AppBuilder = Future<Widget> Function(
  SharedPreferences sharedPreferences,
);

Future<void> bootstrap(AppBuilder builder) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      if (_isSupportAccentColor) {
        await SystemTheme.accentColor.load();
      }

      if (UniversalPlatform.isDesktop) {
        await WindowManager.instance.ensureInitialized();
        await windowManager.waitUntilReadyToShow().then((_) async {
          await windowManager.setTitleBarStyle(
            TitleBarStyle.hidden,
            windowButtonVisibility: false,
          );
          await windowManager.setMinimumSize(const Size(500, 600));
          await windowManager.show();
          await windowManager.setPreventClose(true);
          await windowManager.setSkipTaskbar(false);
        });
      }

      final sharedPreferences = await SharedPreferences.getInstance();

      runApp(
        await builder(sharedPreferences),
      );
    },
    (_, __) {},
  );
}

bool get _isSupportAccentColor {
  if (UniversalPlatform.isWeb) {
    return false;
  }

  return [TargetPlatform.windows, TargetPlatform.android]
      .contains(defaultTargetPlatform);
}
