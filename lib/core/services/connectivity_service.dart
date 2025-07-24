import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _connectivityController = StreamController<ConnectivityResult>.broadcast();
  
  Stream<ConnectivityResult> get connectivityStream => _connectivityController.stream;
  ConnectivityResult? _lastResult;

  ConnectivityService() {
    _initConnectivity();
    _setupConnectivityListener();
  }

  // Initialize connectivity
  Future<void> _initConnectivity() async {
    try {
      _lastResult = await _connectivity.checkConnectivity();
      _connectivityController.add(_lastResult!);
    } catch (e) {
      _connectivityController.add(ConnectivityResult.none);
    }
  }

  // Setup connectivity listener
  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _lastResult = result;
      _connectivityController.add(result);
    });
  }

  // Get current connectivity status
  Future<ConnectivityResult> getConnectivityStatus() async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  // Check if device is connected to internet
  bool get isConnected {
    return _lastResult != null && _lastResult != ConnectivityResult.none;
  }

  // Check if device is connected to WiFi
  bool get isWifiConnected {
    return _lastResult == ConnectivityResult.wifi;
  }

  // Check if device is connected to mobile data
  bool get isMobileConnected {
    return _lastResult == ConnectivityResult.mobile;
  }

  // Check if device is connected to ethernet
  bool get isEthernetConnected {
    return _lastResult == ConnectivityResult.ethernet;
  }

  // Check if device is offline
  bool get isOffline {
    return _lastResult == ConnectivityResult.none;
  }

  // Get connection type as string
  String get connectionType {
    switch (_lastResult) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
      default:
        return 'Offline';
    }
  }

  // Get connection quality based on type
  ConnectionQuality get connectionQuality {
    switch (_lastResult) {
      case ConnectivityResult.ethernet:
        return ConnectionQuality.excellent;
      case ConnectivityResult.wifi:
        return ConnectionQuality.good;
      case ConnectivityResult.mobile:
        return ConnectionQuality.fair;
      case ConnectivityResult.bluetooth:
        return ConnectionQuality.poor;
      case ConnectivityResult.vpn:
        return ConnectionQuality.good;
      case ConnectivityResult.other:
        return ConnectionQuality.unknown;
      case ConnectivityResult.none:
      default:
        return ConnectionQuality.none;
    }
  }

  // Wait for connectivity to be available
  Future<bool> waitForConnectivity({Duration timeout = const Duration(seconds: 30)}) async {
    if (isConnected) return true;

    try {
      await for (ConnectivityResult result in connectivityStream.timeout(timeout)) {
        if (result != ConnectivityResult.none) {
          return true;
        }
      }
    } catch (e) {
      // Timeout occurred
    }
    return false;
  }

  // Dispose resources
  void dispose() {
    _connectivityController.close();
  }
}

// Connection quality enum
enum ConnectionQuality {
  none,
  poor,
  fair,
  good,
  excellent,
  unknown,
}

// Extension to get quality description
extension ConnectionQualityExtension on ConnectionQuality {
  String get description {
    switch (this) {
      case ConnectionQuality.excellent:
        return 'Excellent';
      case ConnectionQuality.good:
        return 'Good';
      case ConnectionQuality.fair:
        return 'Fair';
      case ConnectionQuality.poor:
        return 'Poor';
      case ConnectionQuality.none:
        return 'No Connection';
      case ConnectionQuality.unknown:
      default:
        return 'Unknown';
    }
  }

  double get speed {
    switch (this) {
      case ConnectionQuality.excellent:
        return 100.0;
      case ConnectionQuality.good:
        return 75.0;
      case ConnectionQuality.fair:
        return 50.0;
      case ConnectionQuality.poor:
        return 25.0;
      case ConnectionQuality.none:
        return 0.0;
      case ConnectionQuality.unknown:
      default:
        return 0.0;
    }
  }
} 