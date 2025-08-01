import 'package:flutter/material.dart';
import 'package:riders_choice/features/bikes/domain/entities/bike.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BikeCard extends StatefulWidget {
  final Bike bike;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistToggle;
  final bool isInWishlist;

  const BikeCard({
    Key? key,
    required this.bike,
    this.onTap,
    this.onWishlistToggle,
    this.isInWishlist = false,
  }) : super(key: key);

  @override
  State<BikeCard> createState() => _BikeCardState();
}

class _BikeCardState extends State<BikeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildImageWidget() {
    // Check if the image URL is a network URL or a local asset
    if (widget.bike.imageUrl.startsWith('http') || widget.bike.imageUrl.startsWith('https')) {
      // Network image
      return CachedNetworkImage(
        imageUrl: widget.bike.imageUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 180,
          width: double.infinity,
          color: primaryGreen.withOpacity(0.1),
          child: const Center(
            child: CircularProgressIndicator(
              color: primaryGreen,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 180,
          width: double.infinity,
          color: primaryGreen.withOpacity(0.1),
          child: Icon(
            Icons.motorcycle,
            size: 60,
            color: primaryGreen,
          ),
        ),
      );
    } else {
      // Local asset or backend file
      String imageUrl = widget.bike.imageUrl;
      if (!imageUrl.startsWith('http') && !imageUrl.startsWith('assets/')) {
        // If it's just a filename, construct the backend URL
        imageUrl = 'http://localhost:3000/uploads/$imageUrl';
      }
      
      return CachedNetworkImage(
        imageUrl: imageUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 180,
          width: double.infinity,
          color: primaryGreen.withOpacity(0.1),
          child: const Center(
            child: CircularProgressIndicator(
              color: primaryGreen,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 180,
          width: double.infinity,
          color: primaryGreen.withOpacity(0.1),
          child: Icon(
            Icons.motorcycle,
            size: 60,
            color: primaryGreen,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Card(
              elevation: 8,
              shadowColor: primaryGreen.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        primaryGreen.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image section
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: _buildImageWidget(),
                          ),
                          // Wishlist button
                          if (widget.onWishlistToggle != null)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: widget.onWishlistToggle,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    widget.isInWishlist
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: widget.isInWishlist
                                        ? Colors.red
                                        : primaryGreen,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          // Featured badge
                          if (widget.bike.isFeatured)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryGreen,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Featured',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Content section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Brand and rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.bike.brand,
                                  style: TextStyle(
                                    color: primaryGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.bike.rating.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Bike name
                            Text(
                              widget.bike.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Description
                            Text(
                              widget.bike.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            // Price and stock
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${widget.bike.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryGreen,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.bike.stock > 0
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.bike.stock > 0
                                        ? '${widget.bike.stock} in stock'
                                        : 'Out of stock',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: widget.bike.stock > 0
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // View Details button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: widget.bike.stock > 0
                                    ? widget.onTap
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryGreen,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 