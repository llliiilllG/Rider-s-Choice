import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/accessory_api_service.dart';
import '../widgets/bike_card.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessoriesPage extends StatelessWidget {
  const AccessoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accessoryApi = GetIt.instance<AccessoryApiService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessories'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: accessoryApi.getAllAccessories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load accessories'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No accessories found'));
          }
          final accessories = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.7,
              ),
              itemCount: accessories.length,
              itemBuilder: (context, index) {
                final accessory = accessories[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: isDark ? const Color(0xFF23242B) : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: accessory['imageUrl'].toString().startsWith('http')
                              ? Image.network(
                                  accessory['imageUrl'],
                                  height: 90,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 90,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_not_supported, size: 40),
                                  ),
                                )
                              : Image.asset(
                                  accessory['imageUrl'],
                                  height: 90,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 90,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_not_supported, size: 40),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          accessory['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          accessory['description'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          '\u0024${accessory['price'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  final faceIdEnabled = prefs.getBool('faceIdEnabled') ?? false;
                                  if (faceIdEnabled) {
                                    final authenticated = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Face ID Authentication'),
                                        content: const Text('Simulating Face ID for purchase...'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Authenticate'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (authenticated != true) return;
                                  }
                                  cartProvider.addItem(CartItem(
                                    id: accessory['id'],
                                    name: accessory['name'],
                                    imageUrl: accessory['imageUrl'],
                                    price: accessory['price'],
                                    quantity: 1,
                                    type: 'accessory',
                                  ));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${accessory['name']} added to cart!')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.flash_on, color: Colors.orange),
                              tooltip: 'Buy Now',
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                final faceIdEnabled = prefs.getBool('faceIdEnabled') ?? false;
                                if (faceIdEnabled) {
                                  final authenticated = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Face ID Authentication'),
                                      content: const Text('Simulating Face ID for purchase...'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text('Authenticate'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (authenticated != true) return;
                                }
                                cartProvider.addItem(CartItem(
                                  id: accessory['id'],
                                  name: accessory['name'],
                                  imageUrl: accessory['imageUrl'],
                                  price: accessory['price'],
                                  quantity: 1,
                                  type: 'accessory',
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Purchase successful!')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.white,
    );
  }
} 