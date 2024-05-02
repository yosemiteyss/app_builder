import 'package:app_builder/app_builder.dart';
import 'package:app_builder/service/build/build_service.dart';
import 'package:app_builder/service/preference_service.dart';
import 'package:app_builder/utils/platform.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<PreferenceService>(const PreferenceService());
  getIt.registerSingleton<BuildService>(BuildService(getIt.get()));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (supportAccentColor) {
    await SystemTheme.accentColor.load();
  }

  if (isDesktop) {
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

  setupLocator();
  runApp(const AppBuilder());
}
