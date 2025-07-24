import 'package:flutter/material.dart';
import '../../data/bike_data.dart';
import 'home_page.dart';
import 'accessories_page.dart';
import 'orders_page.dart';
import 'profile_page.dart';
import '../../core/services/sensor_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bike/bike_bloc.dart';
import '../bloc/bike/bike_event.dart';
import '../bloc/bike/bike_state.dart';
import 'cart_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<BikeBloc>().add(GetFeaturedBikesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = true; // Force dark mode for gritty look
    final sensorService = SensorService();
    sensorService.startMonitoring();
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23242B),
        elevation: 0,
        title: const Text("Rider's Choice", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.greenAccent),
            tooltip: 'Cart',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/logo/profile_placeholder.jpg'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Rider!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent[400],
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your ultimate motorcycle marketplace',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          // Quick Actions
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quickAction(context, Icons.motorcycle, 'Browse Bikes', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage())), isDark),
                _quickAction(context, Icons.shopping_bag, 'Accessories', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccessoriesPage())), isDark),
                _quickAction(context, Icons.shopping_cart, 'Orders', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersPage())), isDark),
                _quickAction(context, Icons.person, 'Profile', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())), isDark),
              ],
            ),
          ),
          // Stats
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Card(
              color: const Color(0xFF23242B),
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statCard('Bikes', '8', Icons.pedal_bike, Colors.greenAccent, isDark),
                    _statCard('Accessories', '4', Icons.shopping_bag, Colors.orangeAccent, isDark),
                    _statCard('Orders', '12', Icons.shopping_cart, Colors.purpleAccent, isDark),
                    _statCard('Wishlist', '5', Icons.favorite, Colors.redAccent, isDark),
                  ],
                ),
              ),
            ),
          ),
          // Sensor Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _SensorSummaryCard(sensorService: sensorService, isDark: isDark),
          ),
          // Featured Bikes
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
            child: Text(
              'Featured Bikes',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent[400],
                letterSpacing: 1.1,
              ),
            ),
          ),
          BlocBuilder<BikeBloc, BikeState>(
            builder: (context, state) {
              if (state is BikeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BikeLoaded) {
                final featuredBikes = state.bikes;
                return SizedBox(
                  height: 320,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: featuredBikes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 20),
                    itemBuilder: (context, index) {
                      final bike = featuredBikes[index];
                      return Container(
                        width: 260,
                        child: Card(
                          color: const Color(0xFF23242B),
                          elevation: 10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    appBar: AppBar(title: Text(bike.name)),
                                    body: Center(child: Text('Bike details coming soon!')),
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                  child: Image.network(
                                    bike.imageUrl,
                                    height: 170,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 170,
                                      color: Colors.grey[900],
                                      child: const Icon(Icons.motorcycle, size: 64, color: Colors.greenAccent),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bike.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.greenAccent[400],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        bike.brand,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '\u0024${bike.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is BikeError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _quickAction(BuildContext context, IconData icon, String label, VoidCallback onTap, bool isDark) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDark ? const Color(0xFF23242B) : Colors.white,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: isDark ? Colors.white : Colors.green),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.green,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: isDark ? const Color(0xFF23242B) : Colors.white,
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: 80,
        height: 80,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _featuredBikeCard(BuildContext context, bike, bool isDark) {
    return Container(
      width: 200,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDark ? const Color(0xFF23242B) : Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(title: Text(bike.name)),
                  body: Center(child: Text('Bike details coming soon!')),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  bike.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.motorcycle, size: 64),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bike.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bike.brand,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ' 4${bike.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SensorSummaryCard extends StatelessWidget {
  final SensorService sensorService;
  final bool isDark;
  const _SensorSummaryCard({required this.sensorService, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SensorData>(
      stream: sensorService.sensorDataStream,
      builder: (context, snapshot) {
        final data = snapshot.data;
        final speed = data?.location != null ? (data!.location!.accuracy < 100 ? (data.location!.altitude) : 0.0) : 0.0;
        final orientation = sensorService.calculateOrientation();
        String orientationText;
        switch (orientation) {
          case DeviceOrientation.up:
            orientationText = 'Up';
            break;
          case DeviceOrientation.down:
            orientationText = 'Down';
            break;
          case DeviceOrientation.left:
            orientationText = 'Left';
            break;
          case DeviceOrientation.right:
            orientationText = 'Right';
            break;
          case DeviceOrientation.flat:
            orientationText = 'Flat';
            break;
          default:
            orientationText = 'Unknown';
        }
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: isDark ? const Color(0xFF23242B) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.speed, color: Colors.green, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        '${speed.toStringAsFixed(1)} m',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('Altitude', style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[700])),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.screen_rotation, color: Colors.blue, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        orientationText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('Orientation', style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 