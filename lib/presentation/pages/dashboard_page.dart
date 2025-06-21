import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'accessories_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider\'s Choice'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Rider\'s Choice',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your ultimate motorcycle marketplace',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            
            // Quick Actions Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildActionCard(
                    context,
                    'Browse Motorcycles',
                    Icons.motorcycle,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    ),
                  ),
                  _buildActionCard(
                    context,
                    'Accessories',
                    Icons.shopping_bag,
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccessoriesPage(),
                      ),
                    ),
                  ),
                  _buildActionCard(
                    context,
                    'Categories',
                    Icons.category,
                    Colors.orange,
                    () {
                      // TODO: Navigate to categories page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Categories coming soon!')),
                      );
                    },
                  ),
                  _buildActionCard(
                    context,
                    'My Wishlist',
                    Icons.favorite,
                    Colors.red,
                    () {
                      // TODO: Navigate to wishlist page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wishlist coming soon!')),
                      );
                    },
                  ),
                  _buildActionCard(
                    context,
                    'My Orders',
                    Icons.shopping_cart,
                    Colors.purple,
                    () {
                      // TODO: Navigate to orders page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Orders coming soon!')),
                      );
                    },
                  ),
                  _buildActionCard(
                    context,
                    'Profile',
                    Icons.person,
                    Colors.teal,
                    () {
                      // TODO: Navigate to profile page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
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