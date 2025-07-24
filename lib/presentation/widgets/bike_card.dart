import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/cart_provider.dart';
import '../pages/product_details_page.dart';
import '../../domain/entities/bike.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BikeCard extends StatelessWidget {
  final Bike bike;

  const BikeCard({
    super.key,
    required this.bike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                bike.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.motorcycle,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bike.brand,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              bike.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              ' 4${bike.price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
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
                      Provider.of<CartProvider>(context, listen: false).addItem(
                        CartItem(
                          id: bike.id,
                          name: bike.name,
                          imageUrl: bike.imageUrl,
                          price: bike.price,
                          quantity: 1,
                          type: 'bike',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${bike.name} added to cart!')),
                      );
                    },
                    child: const Text('Add to Cart'),
                  ),
                ),
                const SizedBox(width: 8),
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
                        if (authenticated != true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Face ID did not match. Purchase failed.')),
                          );
                          return;
                        }
                      }
                      Provider.of<CartProvider>(context, listen: false).addItem(
                        CartItem(
                          id: bike.id,
                          name: bike.name,
                          imageUrl: bike.imageUrl,
                          price: bike.price,
                          quantity: 1,
                          type: 'bike',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Purchase successful for ${bike.name}!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Buy Now'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(bikeId: bike.id),
                  ),
                );
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
} 