import 'package:app_builder/router.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:system_theme/system_theme.dart';

final accentColor = AccentColor.swatch({
  'darkest': SystemTheme.accentColor.darkest,
  'darker': SystemTheme.accentColor.darker,
  'dark': SystemTheme.accentColor.dark,
  'normal': SystemTheme.accentColor.accent,
  'light': SystemTheme.accentColor.light,
  'lighter': SystemTheme.accentColor.lighter,
  'lightest': SystemTheme.accentColor.lightest,
});

class AppBuilder extends StatelessWidget {
  const AppBuilder({super.key});

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
      routerConfig: appBuilderRouter,
      localizationsDelegates: const [
        L10n.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}
