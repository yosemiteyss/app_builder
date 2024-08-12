extension IntExtension on int {
  String padZeroLeft(int size) {
    return toString().padLeft(2, '0');
  }
}

const int INT_MAX = 0x7FFFFFFFFFFFFFFF;

const int INT_MIN = -0x8000000000000000;
