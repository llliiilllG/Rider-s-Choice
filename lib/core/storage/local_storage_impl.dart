import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'dart:convert';
import 'local_storage.dart';

@Injectable(as: LocalStorage)
class LocalStorageImpl implements LocalStorage {
  static const String _boxName = 'rider_choice_storage';
  late Box<String> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _box.put(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _box.get(key);
  }

  @override
  Future<void> removeString(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _box.put(key, value.toString());
  }

  @override
  Future<bool?> getBool(String key) async {
    final value = _box.get(key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _box.put(key, value.toString());
  }

  @override
  Future<int?> getInt(String key) async {
    final value = _box.get(key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await _box.put(key, value.toString());
  }

  @override
  Future<double?> getDouble(String key) async {
    final value = _box.get(key);
    if (value == null) return null;
    return double.tryParse(value);
  }

  @override
  Future<void> setObject(String key, Map<String, dynamic> value) async {
    await _box.put(key, jsonEncode(value));
  }

  @override
  Future<Map<String, dynamic>?> getObject(String key) async {
    final value = _box.get(key);
    if (value == null) return null;
    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setList(String key, List<dynamic> value) async {
    await _box.put(key, jsonEncode(value));
  }

  @override
  Future<List<dynamic>?> getList(String key) async {
    final value = _box.get(key);
    if (value == null) return null;
    try {
      return jsonDecode(value) as List<dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _box.containsKey(key);
  }

  @override
  Future<List<String>> getKeys() async {
    return _box.keys.cast<String>().toList();
  }

  Future<void> close() async {
    await _box.close();
  }
} 