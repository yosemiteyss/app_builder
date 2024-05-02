import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

extension BuildContextExtension on BuildContext {
  L10n get l10n => L10n.of(this);
}
