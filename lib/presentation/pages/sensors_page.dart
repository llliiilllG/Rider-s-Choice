import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/services/sensor_service.dart';

class SensorsPage extends StatefulWidget {
  const SensorsPage({super.key});

  @override
  State<SensorsPage> createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
  late final SensorService _sensorService;
  double? _lightLevel;
  bool _autoBrightness = false;
  StreamSubscription? _lightSubscription;
  bool _lightSensorAvailable = true;

  @override
  void initState() {
    super.initState();
    _sensorService = SensorService();
    _sensorService.startMonitoring();
    _listenToLightSensor();
  }

  void _listenToLightSensor() async {
    try {
      // sensors_plus 3.x does not support lightEvents, so we show not available
      setState(() {
        _lightSensorAvailable = false;
        _lightLevel = null;
      });
    } catch (e) {
      setState(() {
        _lightSensorAvailable = false;
        _lightLevel = null;
      });
    }
  }

  void _adjustBrightness(double lux) {
    // Simple logic: <100 = dark, >1000 = light, in between = system
    final brightness = lux < 100
        ? Brightness.dark
        : (lux > 1000 ? Brightness.light : null);
    if (brightness != null && brightness != Theme.of(context).brightness) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auto-brightness: Switched to ${brightness == Brightness.dark ? 'Dark' : 'Light'} Mode')),
      );
    }
  }

  @override
  void dispose() {
    _sensorService.stopMonitoring();
    _lightSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors & Brightness'),
        centerTitle: true,
      ),
      body: StreamBuilder<SensorData>(
        stream: _sensorService.sensorDataStream,
        builder: (context, snapshot) {
          final data = snapshot.data;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Environment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.green[200] : Colors.green[800])),
              const SizedBox(height: 10),
              _sensorCard(
                title: 'Ambient Light',
                icon: Icons.wb_sunny,
                color: Colors.amber,
                content: _lightSensorAvailable
                    ? (_lightLevel != null ? '${_lightLevel!.toStringAsFixed(1)} lux' : 'Waiting for data...')
                    : 'Not available on this device/version',
                isDark: isDark,
                highlight: true,
                trailing: Switch(
                  value: _autoBrightness,
                  onChanged: _lightSensorAvailable
                      ? (val) {
                          setState(() => _autoBrightness = val);
                        }
                      : null,
                  activeColor: Colors.green,
                ),
                trailingLabel: 'Auto-brightness',
              ),
              const SizedBox(height: 28),
              Text('Motion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.blue[200] : Colors.blue[800])),
              const SizedBox(height: 10),
              _sensorCard(
                title: 'Accelerometer',
                icon: Icons.directions_run,
                color: Colors.orange,
                content: data?.accelerometer != null
                    ? 'x: ${data!.accelerometer!.x.toStringAsFixed(2)}\ny: ${data.accelerometer!.y.toStringAsFixed(2)}\nz: ${data.accelerometer!.z.toStringAsFixed(2)}'
                    : 'No data',
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _sensorCard(
                title: 'Gyroscope',
                icon: Icons.threesixty,
                color: Colors.blue,
                content: data?.gyroscope != null
                    ? 'x: ${data!.gyroscope!.x.toStringAsFixed(2)}\ny: ${data.gyroscope!.y.toStringAsFixed(2)}\nz: ${data.gyroscope!.z.toStringAsFixed(2)}'
                    : 'No data',
                isDark: isDark,
              ),
              const SizedBox(height: 28),
              Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.purple[200] : Colors.purple[800])),
              const SizedBox(height: 10),
              _sensorCard(
                title: 'Location',
                icon: Icons.location_on,
                color: Colors.green,
                content: data?.location != null
                    ? 'Lat: ${data!.location!.latitude.toStringAsFixed(5)}\nLng: ${data.location!.longitude.toStringAsFixed(5)}\nAlt: ${data.location!.altitude.toStringAsFixed(1)} m\nAccuracy: ${data.location!.accuracy.toStringAsFixed(1)} m'
                    : 'No data',
                isDark: isDark,
              ),
            ],
          );
        },
      ),
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.white,
    );
  }

  Widget _sensorCard({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
    required bool isDark,
    Widget? trailing,
    String? trailingLabel,
    bool highlight = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: highlight
            ? LinearGradient(
                colors: isDark
                    ? [const Color(0xFF2E3C2F), const Color(0xFF1B2B1B)]
                    : [const Color(0xFFE8F5E9), const Color(0xFFF1F8E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  if (trailing != null) ...[
                    const Spacer(),
                    Column(
                      children: [
                        trailing,
                        if (trailingLabel != null)
                          Text(trailingLabel, style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[400] : Colors.grey[700])),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[200] : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 