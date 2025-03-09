/// {@template padding_extensions}
/// Padding extension methods on [int] type.
/// {@endtemplate}
extension PaddingExtensions on int {
  /// Adding left zero padding.
  String padZeroLeft(int size) {
    return toString().padLeft(2, '0');
  }
}

/// Max value for [int].
const int INT_MAX = 0x7FFFFFFFFFFFFFFF;

/// Min value for [int].
const int INT_MIN = -0x8000000000000000;
