abstract class LocalStorage {
  // String operations
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> removeString(String key);
  
  // Boolean operations
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  
  // Integer operations
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  
  // Double operations
  Future<void> setDouble(String key, double value);
  Future<double?> getDouble(String key);
  
  // Object operations (JSON)
  Future<void> setObject(String key, Map<String, dynamic> value);
  Future<Map<String, dynamic>?> getObject(String key);
  
  // List operations
  Future<void> setList(String key, List<dynamic> value);
  Future<List<dynamic>?> getList(String key);
  
  // Clear all data
  Future<void> clear();
  
  // Check if key exists
  Future<bool> containsKey(String key);
  
  // Get all keys
  Future<List<String>> getKeys();
} 