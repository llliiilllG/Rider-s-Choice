import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'local_storage.dart';

class HiveStorage implements LocalStorage {
  static const String _boxName = 'riders_choice_storage';
  late Box<String> _box;

  Future<void> _initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<String>(_boxName);
    } else {
      _box = Hive.box<String>(_boxName);
    }
  }

  @override
  Future<void> setString(String key, String value) async {
    await _initBox();
    await _box.put(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    await _initBox();
    return _box.get(key);
  }

  @override
  Future<void> removeString(String key) async {
    await _initBox();
    await _box.delete(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await setString(key, value.toString());
  }

  @override
  Future<bool?> getBool(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  @override
  Future<void> setInt(String key, int value) async {
    await setString(key, value.toString());
  }

  @override
  Future<int?> getInt(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await setString(key, value.toString());
  }

  @override
  Future<double?> getDouble(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return double.tryParse(value);
  }

  @override
  Future<void> setObject(String key, Map<String, dynamic> value) async {
    await setString(key, jsonEncode(value));
  }

  @override
  Future<Map<String, dynamic>?> getObject(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setList(String key, List<dynamic> value) async {
    await setString(key, jsonEncode(value));
  }

  @override
  Future<List<dynamic>?> getList(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    try {
      return jsonDecode(value) as List<dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clear() async {
    await _initBox();
    await _box.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    await _initBox();
    return _box.containsKey(key);
  }

  @override
  Future<List<String>> getKeys() async {
    await _initBox();
    return _box.keys.cast<String>().toList();
  }
} 