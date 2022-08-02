class JsonToArbConverter {
  Map<String, dynamic> toArb({
    required Map<String, dynamic> json,
    required String locale,
  }) {
    final arbMap = <String, dynamic>{};
    arbMap["@@locale"] = locale;
    final flattenedKeyMap = json.entries.fold(
      <String, dynamic>{},
      (Map<String, dynamic> accumulator, entry) =>
          accumulator..addFlattenedEntry(entry),
    );
    arbMap.addAll(flattenedKeyMap);

    final Map<String, dynamic> processedArbMap = {};
    arbMap.forEach((key, value) {
      // 1. Skips
      // 1.1 skip any entry when its key begins with a dot
      if (key[0] == '.') {
        return;
      }

      // 2. Transformations
      // 2.1 Make first letter lower case (camel case)
      String newKey = key[0].toLowerCase() + key.substring(1);
      // 2.2 Replace all dots with underscore
      newKey = newKey.replaceAll('.', '');

      processedArbMap[newKey] = value;
    });
    return processedArbMap;
  }
}

extension _MapExtension<K, V> on Map<K, V> {
  void addFlattenedEntry(MapEntry<K, V> entry) {
    final value = entry.value;
    if (value is Map<K, V>) {
      value.entries.forEach((it) => addFlattenedEntry(it));
    } else {
      this[entry.key] = entry.value;
    }
  }
}
