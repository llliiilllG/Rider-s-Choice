import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../viewmodels/bikes_viewmodel.dart';
import '../widgets/bike_card.dart';
import '../pages/bike_details_page.dart';
import 'package:riders_choice/features/bikes/domain/entities/bike.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/services/bike_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
          index: _currentIndex,
        children: [
          // Home Tab
          ChangeNotifierProvider<BikesViewModel>.value(
            value: getIt<BikesViewModel>()..loadBikes(),
            child: Consumer<BikesViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (viewModel.errorMessage != null) {
                  return Center(child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)));
                }
                final bikes = List.of(viewModel.bikes);
                // Sort by createdAt descending if available
                bikes.sort((a, b) {
                  if (a.createdAt == null || b.createdAt == null) return 0;
                  return b.createdAt.compareTo(a.createdAt);
                });
                // Get unique categories from bikes
                final categories = bikes.map((b) => b.category).toSet().toList();
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Categories
                    if (categories.isNotEmpty) ...[
                      const Text(
                        'Categories',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (context, i) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return Chip(
                              label: Text(category, style: const TextStyle(color: Colors.white)),
                              backgroundColor: Colors.grey[850],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Recently Added Bikes
                    const Text(
                      'Recently Added Bikes',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    bikes.isEmpty
                        ? const Center(child: Text('No bikes available'))
                        : SizedBox(
                            height: 220,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: bikes.length,
                              separatorBuilder: (context, i) => const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final bike = bikes[index];
                                return Container(
                                  width: 180,
                                  child: Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BikeDetailsPage(bikeId: bike.id),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                              child: bike.imageUrl != null && bike.imageUrl.isNotEmpty
                                                  ? Image.network(
                                                      bike.imageUrl,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.motorcycle, size: 64, color: Colors.grey),
                                                    )
                                                  : const Icon(Icons.motorcycle, size: 64, color: Colors.grey),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  bike.name,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '\u20B9${bike.price}',
                                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.green),
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
                          ),
                    const SizedBox(height: 28),
                    // Browse All Bikes
                    const Text(
                      'Browse All Bikes',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    bikes.isEmpty
                        ? const Center(child: Text('No bikes available'))
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: bikes.length,
                            itemBuilder: (context, index) {
                              final bike = bikes[index];
                              return Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BikeDetailsPage(bikeId: bike.id),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                          child: bike.imageUrl != null && bike.imageUrl.isNotEmpty
                                              ? Image.network(
                                                  bike.imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.motorcycle, size: 64, color: Colors.grey),
                                                )
                                              : const Icon(Icons.motorcycle, size: 64, color: Colors.grey),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              bike.name,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '\u20B9${bike.price}',
                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.green),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                );
              },
            ),
          ),
          // Bikes Tab Placeholder
          const Center(child: Text('Bikes Tab')), 
          // Cart Tab Placeholder
          const Center(child: Text('Cart Tab')), 
          // Orders Tab Placeholder
          const Center(child: Text('Orders Tab')), 
          // Profile Tab Placeholder
          const Center(child: Text('Profile Tab')), 
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.motorcycle_outlined),
            activeIcon: Icon(Icons.motorcycle),
            label: 'Bikes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            activeIcon: Icon(Icons.receipt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  late BikesViewModel _bikesViewModel;
  List<Bike> _recentBikes = [];

  @override
  void initState() {
    super.initState();
    _bikesViewModel = getIt<BikesViewModel>();
    _loadData();
    _loadRecentBikes();
  }

  Future<void> _loadData() async {
    await _bikesViewModel.loadFeaturedBikes();
  }

  Future<void> _loadRecentBikes() async {
    final api = GetIt.instance<BikeApiService>();
    final recent = await api.getRecentlyAddedBikes();
    setState(() {
      _recentBikes = recent.map((b) => Bike.fromJson(b as Map<String, dynamic>)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider\'s Choice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryGreen, darkGreen],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Rider\'s Choice',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover the perfect bike for your adventure',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Featured Bikes Section
            Text(
              'Featured Bikes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ChangeNotifierProvider.value(
              value: _bikesViewModel,
              child: Consumer<BikesViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (viewModel.errorMessage != null) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Failed to load bikes',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _loadData,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (viewModel.featuredBikes.isEmpty) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('No featured bikes available'),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 400,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: viewModel.featuredBikes.length,
                      itemBuilder: (context, index) {
                        final bike = viewModel.featuredBikes[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: BikeCard(
                            bike: bike,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BikeDetailsPage(bikeId: bike.id),
                                ),
                              );
                            },
                            onWishlistToggle: () {
                              // TODO: Toggle wishlist
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Recently Added Section
            if (_recentBikes.isNotEmpty) ...[
              Text(
                'Recently Added',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recentBikes.length,
                  itemBuilder: (context, index) {
                    final bike = _recentBikes[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: BikeCard(
                        bike: bike,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BikeDetailsPage(bikeId: bike.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Categories Section
            Text(
              'Categories',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: AppConstants.bikeCategories.length,
              itemBuilder: (context, index) {
                return _CategoryCard(
                  category: AppConstants.bikeCategories[index],
                  icon: _getCategoryIcon(AppConstants.bikeCategories[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Sport':
        return Icons.speed;
      case 'Cruiser':
        return Icons.directions_car;
      case 'Adventure':
        return Icons.terrain;
      case 'Naked':
        return Icons.motorcycle;
      case 'Touring':
        return Icons.map;
      default:
        return Icons.motorcycle;
    }
  }
}



class _CategoryCard extends StatelessWidget {
  final String category;
  final IconData icon;

  const _CategoryCard({
    required this.category,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: primaryGreen,
              ),
              const SizedBox(height: 8),
              Text(
                category,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BikesTab extends StatelessWidget {
  const _BikesTab();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bikes Tab - Coming Soon'),
      ),
    );
  }
}

class _CartTab extends StatelessWidget {
  const _CartTab();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Cart Tab - Coming Soon'),
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Orders Tab - Coming Soon'),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile Tab - Coming Soon'),
      ),
    );
  }
} 