import 'package:flutter_test/flutter_test.dart';

/// Global test configuration and setup
class TestConfig {
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration defaultPumpTimeout = Duration(milliseconds: 500);
  
  /// Common test setup that runs before each test
  static void setUpAll() {
    // Set up any global test configuration here
    TestWidgetsFlutterBinding.ensureInitialized();
  }
  
  /// Common test teardown that runs after each test
  static void tearDownAll() {
    // Clean up any global test resources here
  }
  
  /// Helper method to create a test description
  static String describe(String description) {
    return 'Test: $description';
  }
  
  /// Helper method to create a group description
  static String groupDescribe(String description) {
    return 'Group: $description';
  }
} 