import 'package:flutter_test/flutter_test.dart';
import 'package:riders_choice/core/services/sensor_service.dart';

void main() {
  group('SensorService', () {
    late SensorService sensorService;

    setUp(() {
      sensorService = SensorService();
    });

    test('should initialize with default sensor data', () {
      expect(sensorService.currentData.accelerometer, isNull);
      expect(sensorService.currentData.gyroscope, isNull);
      expect(sensorService.currentData.location, isNull);
    });

    test('should calculate device orientation correctly', () {
      // Test unknown orientation when no accelerometer data
      expect(sensorService.calculateOrientation(), equals(DeviceOrientation.unknown));
    });

    test('should detect device movement correctly', () {
      // Test no movement when no accelerometer data
      expect(sensorService.isDeviceMoving(), isFalse);
    });

    test('should dispose resources correctly', () {
      expect(() => sensorService.dispose(), returnsNormally);
    });
  });

  group('SensorData', () {
    test('should create initial sensor data', () {
      final data = SensorData.initial();
      expect(data.accelerometer, isNull);
      expect(data.gyroscope, isNull);
      expect(data.location, isNull);
    });

    test('should copy sensor data with new values', () {
      final initialData = SensorData.initial();
      final accelerometerData = AccelerometerData(
        x: 1.0,
        y: 2.0,
        z: 3.0,
        timestamp: DateTime.now(),
      );

      final updatedData = initialData.copyWith(accelerometer: accelerometerData);
      expect(updatedData.accelerometer, equals(accelerometerData));
      expect(updatedData.gyroscope, isNull);
      expect(updatedData.location, isNull);
    });
  });

  group('AccelerometerData', () {
    test('should create accelerometer data correctly', () {
      final timestamp = DateTime.now();
      final data = AccelerometerData(
        x: 1.5,
        y: 2.5,
        z: 3.5,
        timestamp: timestamp,
      );

      expect(data.x, equals(1.5));
      expect(data.y, equals(2.5));
      expect(data.z, equals(3.5));
      expect(data.timestamp, equals(timestamp));
    });
  });

  group('GyroscopeData', () {
    test('should create gyroscope data correctly', () {
      final timestamp = DateTime.now();
      final data = GyroscopeData(
        x: 0.1,
        y: 0.2,
        z: 0.3,
        timestamp: timestamp,
      );

      expect(data.x, equals(0.1));
      expect(data.y, equals(0.2));
      expect(data.z, equals(0.3));
      expect(data.timestamp, equals(timestamp));
    });
  });

  group('LocationData', () {
    test('should create location data correctly', () {
      final timestamp = DateTime.now();
      final data = LocationData(
        latitude: 37.7749,
        longitude: -122.4194,
        altitude: 100.0,
        accuracy: 5.0,
        timestamp: timestamp,
      );

      expect(data.latitude, equals(37.7749));
      expect(data.longitude, equals(-122.4194));
      expect(data.altitude, equals(100.0));
      expect(data.accuracy, equals(5.0));
      expect(data.timestamp, equals(timestamp));
    });
  });

  group('DeviceOrientation', () {
    test('should have correct enum values', () {
      expect(DeviceOrientation.values.length, equals(6));
      expect(DeviceOrientation.unknown, isNotNull);
      expect(DeviceOrientation.up, isNotNull);
      expect(DeviceOrientation.down, isNotNull);
      expect(DeviceOrientation.left, isNotNull);
      expect(DeviceOrientation.right, isNotNull);
      expect(DeviceOrientation.flat, isNotNull);
    });
  });
} 