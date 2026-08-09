import 'package:hive_flutter/hive_flutter.dart';

import '../local_storage.dart';

class HiveLocalStorage implements LocalStorage {
  static const boxName = 'bite_go_local_storage';

  HiveLocalStorage() : _box = Hive.box(boxName);

  final Box _box;

  @override
  Future<void> write<T>(String key, T value) => _box.put(key, value);

  @override
  T? read<T>(String key) => _box.get(key);

  @override
  Future<void> delete(String key) => _box.delete(key);

  @override
  Future<void> clear() => _box.clear();

  @override
  bool contains(String key) => _box.containsKey(key);
}
