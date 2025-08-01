import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userName;
  String? _userEmail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'Demo User';
      _userEmail = prefs.getString('userEmail') ?? 'demo@example.com';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  
                  // Profile Options
                  _buildProfileOptions(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryGreen.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 50,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            
            // User Name
            Text(
              _userName ?? 'Demo User',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            
            // User Email
            Text(
              _userEmail ?? 'demo@example.com',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to edit profile
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Card(
      child: Column(
        children: [
          _buildProfileOption(
            icon: Icons.shopping_bag,
            title: 'My Orders',
            subtitle: 'View your order history',
            onTap: () {
              // TODO: Navigate to orders
            },
          ),
          _buildProfileOption(
            icon: Icons.favorite,
            title: 'Wishlist',
            subtitle: 'Your saved bikes',
            onTap: () {
              // TODO: Navigate to wishlist
            },
          ),
          _buildProfileOption(
            icon: Icons.location_on,
            title: 'Addresses',
            subtitle: 'Manage delivery addresses',
            onTap: () {
              // TODO: Navigate to addresses
            },
          ),
          _buildProfileOption(
            icon: Icons.payment,
            title: 'Payment Methods',
            subtitle: 'Manage payment options',
            onTap: () {
              // TODO: Navigate to payment methods
            },
          ),
          _buildProfileOption(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {
              // TODO: Navigate to notifications
            },
          ),
          _buildProfileOption(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () {
              // TODO: Navigate to help
            },
          ),
          _buildProfileOption(
            icon: Icons.info,
            title: 'About',
            subtitle: 'App version and information',
            onTap: () {
              // TODO: Navigate to about
            },
          ),
          _buildProfileOption(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : primaryGreen,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
} 