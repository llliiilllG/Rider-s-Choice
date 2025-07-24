import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class SensorService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<Position>? _locationSubscription;
  
  final StreamController<SensorData> _sensorDataController = StreamController<SensorData>.broadcast();
  Stream<SensorData> get sensorDataStream => _sensorDataController.stream;

  // Sensor data state
  SensorData _currentData = SensorData.initial();
  SensorData get currentData => _currentData;

  // Start monitoring all sensors
  Future<void> startMonitoring() async {
    await _requestPermissions();
    _startAccelerometer();
    _startGyroscope();
    _startLocationTracking();
  }

  // Stop monitoring all sensors
  void stopMonitoring() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _locationSubscription?.cancel();
  }

  // Request necessary permissions
  Future<void> _requestPermissions() async {
    // Request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }
  }

  // Start accelerometer monitoring
  void _startAccelerometer() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      _currentData = _currentData.copyWith(
        accelerometer: AccelerometerData(
          x: event.x,
          y: event.y,
          z: event.z,
          timestamp: DateTime.now(),
        ),
      );
      _sensorDataController.add(_currentData);
    });
  }

  // Start gyroscope monitoring
  void _startGyroscope() {
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      _currentData = _currentData.copyWith(
        gyroscope: GyroscopeData(
          x: event.x,
          y: event.y,
          z: event.z,
          timestamp: DateTime.now(),
        ),
      );
      _sensorDataController.add(_currentData);
    });
  }

  // Start location tracking
  void _startLocationTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _locationSubscription = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _currentData = _currentData.copyWith(
        location: LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          altitude: position.altitude,
          accuracy: position.accuracy,
          timestamp: DateTime.now(),
        ),
      );
      _sensorDataController.add(_currentData);
    });
  }

  // Get current location once
  Future<LocationData?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: position.accuracy,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  // Calculate device orientation based on accelerometer
  DeviceOrientation calculateOrientation() {
    final acc = _currentData.accelerometer;
    if (acc == null) return DeviceOrientation.unknown;

    final x = acc.x.abs();
    final y = acc.y.abs();
    final z = acc.z.abs();

    if (z > x && z > y) {
      return DeviceOrientation.flat;
    } else if (x > y && x > z) {
      return acc.x > 0 ? DeviceOrientation.left : DeviceOrientation.right;
    } else {
      return acc.y > 0 ? DeviceOrientation.down : DeviceOrientation.up;
    }
  }

  // Detect device movement/shake
  bool isDeviceMoving() {
    final acc = _currentData.accelerometer;
    if (acc == null) return false;

    // Calculate acceleration magnitude
    final magnitude = sqrt(acc.x * acc.x + acc.y * acc.y + acc.z * acc.z);
    return magnitude > 15.0; // Threshold for movement detection
  }

  // Dispose resources
  void dispose() {
    stopMonitoring();
    _sensorDataController.close();
  }
}

// Data classes for sensor information
class SensorData {
  final AccelerometerData? accelerometer;
  final GyroscopeData? gyroscope;
  final LocationData? location;

  const SensorData({
    this.accelerometer,
    this.gyroscope,
    this.location,
  });

  factory SensorData.initial() => const SensorData();

  SensorData copyWith({
    AccelerometerData? accelerometer,
    GyroscopeData? gyroscope,
    LocationData? location,
  }) {
    return SensorData(
      accelerometer: accelerometer ?? this.accelerometer,
      gyroscope: gyroscope ?? this.gyroscope,
      location: location ?? this.location,
    );
  }
}

class AccelerometerData {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  const AccelerometerData({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });
}

class GyroscopeData {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  const GyroscopeData({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });
}

class LocationData {
  final double latitude;
  final double longitude;
  final double altitude;
  final double accuracy;
  final DateTime timestamp;

  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.accuracy,
    required this.timestamp,
  });
}

enum DeviceOrientation {
  unknown,
  up,
  down,
  left,
  right,
  flat,
} 