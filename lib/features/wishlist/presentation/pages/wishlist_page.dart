import 'package:flutter/material.dart';
import '../../../../core/services/wishlist_service.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final WishlistService _wishlistService = WishlistService();
  List<Map<String, dynamic>> _wishlistItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final items = await _wishlistService.getWishlist();
      setState(() {
        _wishlistItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load wishlist: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromWishlist(String bikeId) async {
    try {
      final success = await _wishlistService.removeFromWishlist(bikeId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from wishlist'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadWishlist(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to remove from wishlist'),
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

  Widget _buildImageWidget(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(
          Icons.motorcycle,
          color: Colors.grey,
          size: 64,
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
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[200],
        child: const Icon(
          Icons.motorcycle,
          color: Colors.grey,
          size: 64,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          if (_wishlistItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadWishlist,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWishlist,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _wishlistItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your wishlist is empty',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add bikes to your wishlist to see them here!',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigate to bikes tab
                              // You might need to implement this navigation
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Browse Bikes'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadWishlist,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _wishlistItems.length,
                        itemBuilder: (context, index) {
                          final item = _wishlistItems[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: _buildImageWidget(item['image'] ?? ''),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'] ?? item['name'] ?? 'Unknown Bike',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['brand'] ?? 'Unknown Brand',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '₹${(item['price'] ?? 0).toStringAsFixed(0)}',
                                          style: TextStyle(
                                            color: primaryGreen,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Remove button
                                  IconButton(
                                    onPressed: () => _removeFromWishlist(item['_id']),
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    tooltip: 'Remove from wishlist',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
} 