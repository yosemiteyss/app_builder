extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> toCopy() => Map.of(this);
}
