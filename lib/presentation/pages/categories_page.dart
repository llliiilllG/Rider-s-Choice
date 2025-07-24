import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Categories coming soon!',
          style: TextStyle(
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
} 