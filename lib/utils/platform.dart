import 'package:flutter/foundation.dart';

bool get isDesktop {
  if (kIsWeb) {
    return false;
  }

  return [TargetPlatform.windows, TargetPlatform.linux, TargetPlatform.macOS]
      .contains(defaultTargetPlatform);
}

bool get isSupportAccentColor {
  if (kIsWeb) {
    return false;
  }

  return [TargetPlatform.windows, TargetPlatform.android]
      .contains(defaultTargetPlatform);
}
