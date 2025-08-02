import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/sensor_service.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/services/payment_service.dart';
import '../../../../core/services/wishlist_service.dart';
import '../../../../core/services/connectivity_service.dart';
import 'package:riders_choice/features/bikes/domain/entities/bike.dart';
import '../widgets/bike_card.dart';
import '../../../../core/services/bike_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/order_api_service.dart';
import '../../../../core/services/cart_service.dart';
import '../../../../core/services/payment_service.dart';
import '../../../../core/widgets/payment_options_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BikeDetailsPage extends StatefulWidget {
  final String bikeId;

  const BikeDetailsPage({
    Key? key,
    required this.bikeId,
  }) : super(key: key);

  @override
  State<BikeDetailsPage> createState() => _BikeDetailsPageState();
}

class _BikeDetailsPageState extends State<BikeDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late SensorService _sensorService;
  late WebSocketService _webSocketService;
  late PaymentService _paymentService;
  late ConnectivityService _connectivityService;
  final CartService _cartService = CartService();
  final WishlistService _wishlistService = WishlistService();

  bool _isInWishlist = false;
  int _quantity = 1;
  bool _isLoading = true;
  String? _errorMessage;
  Bike? _bike;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _setupAnimations();
    _fetchBikeDetails();
  }

  void _initializeServices() {
    _sensorService = getIt<SensorService>();
    _webSocketService = getIt<WebSocketService>();
    _paymentService = getIt<PaymentService>();
    _connectivityService = getIt<ConnectivityService>();
  }

  Future<void> _checkWishlistStatus() async {
    if (_bike != null) {
      final isInWishlist = await _wishlistService.isInWishlist(_bike!.id);
      setState(() {
        _isInWishlist = isInWishlist;
      });
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  Future<void> _fetchBikeDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final api = getIt<BikeApiService>();
      final bike = await api.getBikeById(widget.bikeId);
      setState(() {
        _bike = bike;
        _isLoading = false;
      });
      _animationController.forward();
      if (bike != null) {
        _webSocketService.sendBikeView(bike.id);
        await _checkWishlistStatus(); // Check if bike is in wishlist
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load bike details.';
        _isLoading = false;
      });
    }
  }

  Widget _buildBikeImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        color: primaryGreen.withOpacity(0.1),
        child: Icon(
          Icons.motorcycle,
          size: 100,
          color: primaryGreen,
        ),
      );
    }
    
    // If it's just a filename, construct the backend URL
    String fullImageUrl = imageUrl;
    if (!imageUrl.startsWith('http') && !imageUrl.startsWith('assets/')) {
      fullImageUrl = 'http://localhost:3000/uploads/$imageUrl';
    }
    
    return CachedNetworkImage(
      imageUrl: fullImageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: primaryGreen.withOpacity(0.1),
        child: const Center(
          child: CircularProgressIndicator(
            color: primaryGreen,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: primaryGreen.withOpacity(0.1),
        child: Icon(
          Icons.motorcycle,
          size: 100,
          color: primaryGreen,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))),
      );
    }
    final bike = _bike!;
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildBikeImage(bike.imageUrl),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Featured badge
                    if (bike.isFeatured)
                      Positioned(
                        top: 60,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Featured',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  bike.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isInWishlist ? Icons.favorite : Icons.favorite_border,
                    color: _isInWishlist ? Colors.red : Colors.white,
                  ),
                  onPressed: _toggleWishlist,
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: _shareBike,
                ),
              ],
            ),
            // Content
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${bike.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                bike.rating.toString(),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Brand and Category
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              bike.brand,
                              style: TextStyle(
                                color: primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              bike.category,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bike.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Specifications
                      Text(
                        'Specifications',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSpecificationsCard(),
                      const SizedBox(height: 24),

                      // Stock Status
                      _buildStockStatusCard(),
                      const SizedBox(height: 24),

                      // Quantity Selector
                      _buildQuantitySelector(),
                      const SizedBox(height: 24),

                      // Action Buttons
                      _buildActionButtons(),
                      const SizedBox(height: 24),

                      // Reviews Section
                      if (bike.reviews.isNotEmpty) ...[
                        Text(
                          'Reviews',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildReviewsSection(),
                        const SizedBox(height: 24),
                      ],

                      // Sensor Integration Demo
                      _buildSensorIntegrationCard(),
                      const SizedBox(height: 24),

                      // Connectivity Status
                      _buildConnectivityStatusCard(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificationsCard() {
    final specs = _bike!.specifications;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSpecRow('Engine', specs.engine),
            _buildSpecRow('Power', specs.power),
            _buildSpecRow('Torque', specs.torque),
            _buildSpecRow('Transmission', specs.transmission),
            _buildSpecRow('Weight', specs.weight),
            _buildSpecRow('Fuel Capacity', specs.fuelCapacity),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockStatusCard() {
    final isInStock = _bike!.stock > 0;
    return Card(
      elevation: 2,
      color: isInStock ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isInStock ? Icons.check_circle : Icons.cancel,
              color: isInStock ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isInStock ? 'In Stock' : 'Out of Stock',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isInStock ? Colors.green : Colors.red,
                    ),
                  ),
                  if (isInStock)
                    Text(
                      '${_bike!.stock} units available',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              'Quantity:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            IconButton(
              onPressed: _quantity > 1 ? _decreaseQuantity : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '$_quantity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: _quantity < _bike!.stock ? _increaseQuantity : null,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _bike!.stock > 0 && !_isLoading ? _addToCart : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _bike!.stock > 0 ? _buyNow : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryGreen,
              side: const BorderSide(color: primaryGreen),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Buy Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: _bike!.reviews.map((review) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: primaryGreen,
                        child: Text(
                          review.userName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < review.rating ? Icons.star : Icons.star_border,
                                  size: 16,
                                  color: Colors.amber,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatDate(review.date),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(review.comment),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSensorIntegrationCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sensors, color: primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'Sensor Integration',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StreamBuilder<SensorData>(
              stream: _sensorService.sensorDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Column(
                    children: [
                      _buildSensorRow('Orientation', _sensorService.calculateOrientation().name),
                      _buildSensorRow('Movement', _sensorService.isDeviceMoving() ? 'Yes' : 'No'),
                      if (data.location != null)
                        _buildSensorRow('Location', '${data.location!.latitude.toStringAsFixed(4)}, ${data.location!.longitude.toStringAsFixed(4)}'),
                    ],
                  );
                }
                return const Text('Initializing sensors...');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectivityStatusCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wifi, color: primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'Connection Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StreamBuilder<ConnectivityResult>(
              stream: _connectivityService.connectivityStream,
              builder: (context, snapshot) {
                final isConnected = _connectivityService.isConnected;
                final connectionType = _connectivityService.connectionType;
                final quality = _connectivityService.connectionQuality;
                
                return Column(
                  children: [
                    _buildSensorRow('Status', isConnected ? 'Connected' : 'Offline'),
                    _buildSensorRow('Type', connectionType),
                    _buildSensorRow('Quality', quality.description),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleWishlist() async {
    if (_bike == null) return;
    
    try {
      bool success;
      if (_isInWishlist) {
        success = await _wishlistService.removeFromWishlist(_bike!.id);
      } else {
        success = await _wishlistService.addToWishlist(_bike!.id);
      }
      
      if (success) {
        setState(() {
          _isInWishlist = !_isInWishlist;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isInWishlist ? 'Added to wishlist!' : 'Removed from wishlist!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update wishlist'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _shareBike() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon!')),
    );
  }

  void _increaseQuantity() {
    if (_quantity < _bike!.stock) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<String> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    
    // If no user is logged in, use a demo user ID for testing
    if (userId.isEmpty) {
      userId = 'demo_user_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('userId', userId);
    }
    
    return userId;
  }

  void _addToCart() async {
    setState(() => _isLoading = true);
    try {
      await _cartService.addToCart(_bike!, _quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to cart successfully!')),
      );
      Navigator.pushNamed(context, '/cart');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _buyNow() async {
    if (_bike == null) return;
    
    // Create a single cart item for buy now
    final cartItem = CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bikeId: _bike!.id,
      bikeName: _bike!.name,
      bikeBrand: _bike!.brand,
      price: _bike!.price,
      imageUrl: _bike!.imageUrl,
      quantity: _quantity,
      addedAt: DateTime.now(),
    );
    
    // Show payment options
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentOptionsSheet(
        cartItems: [cartItem],
        totalAmount: _bike!.price * _quantity,
        onPaymentComplete: () {
          Navigator.pop(context);
          Navigator.pop(context); // Go back to previous screen
          // Refresh orders page if it's open
          Navigator.pushNamed(context, '/orders');
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 