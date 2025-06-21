import '../domain/entities/bike.dart';
import 'models/bike_model.dart';

class BikeData {
  static final List<Bike> allBikes = [
    BikeModel(
      id: '1',
      name: 'Ducati Panigale V4',
      brand: 'Ducati',
      price: 24999,
      category: 'Sport',
      imageUrl: 'assets/motorcycles/ducati_panigale.jpg',
      description: 'The Ducati Panigale V4 is the first Ducati production bike to use a 4-cylinder engine. It features advanced electronics, aerodynamic design, and incredible performance.',
      specifications: const BikeSpecifications(
        engine: '1103cc V4',
        power: '214 hp',
        torque: '91.5 lb-ft',
        transmission: '6-speed',
        weight: '430 lbs',
        fuelCapacity: '4.2 gallons',
      ),
      stock: 5,
      isFeatured: true,
      rating: 4.8,
      reviews: [
        Review(
          userId: 'user1',
          userName: 'John Rider',
          rating: 5,
          comment: 'Amazing bike! The power delivery is incredible.',
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Review(
          userId: 'user2',
          userName: 'Sarah Speed',
          rating: 4,
          comment: 'Great handling and looks stunning.',
          date: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ],
    ),
    BikeModel(
      id: '2',
      name: 'BMW S1000RR',
      brand: 'BMW',
      price: 18995,
      category: 'Sport',
      imageUrl: 'assets/motorcycles/bmw_s1000rr.jpg',
      description: 'The BMW S1000RR is a high-performance sport bike with advanced electronics, dynamic traction control, and race-inspired design.',
      specifications: const BikeSpecifications(
        engine: '999cc Inline-4',
        power: '205 hp',
        torque: '83 lb-ft',
        transmission: '6-speed',
        weight: '434 lbs',
        fuelCapacity: '4.4 gallons',
      ),
      stock: 8,
      isFeatured: true,
      rating: 4.7,
      reviews: [
        Review(
          userId: 'user3',
          userName: 'Mike Motor',
          rating: 5,
          comment: 'Perfect balance of power and control.',
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    ),
    BikeModel(
      id: '3',
      name: 'Yamaha YZF-R1',
      brand: 'Yamaha',
      price: 17999,
      category: 'Sport',
      imageUrl: 'assets/motorcycles/yamaha_r1.jpg',
      description: 'The Yamaha YZF-R1 is a superbike with MotoGP-inspired technology, including a crossplane crankshaft engine and advanced electronics.',
      specifications: const BikeSpecifications(
        engine: '998cc Inline-4',
        power: '200 hp',
        torque: '83 lb-ft',
        transmission: '6-speed',
        weight: '448 lbs',
        fuelCapacity: '4.5 gallons',
      ),
      stock: 6,
      isFeatured: true,
      rating: 4.6,
      reviews: [
        Review(
          userId: 'user4',
          userName: 'Alex Yamaha',
          rating: 4,
          comment: 'Great track bike with excellent electronics.',
          date: DateTime.now().subtract(const Duration(days: 7)),
        ),
      ],
    ),
    BikeModel(
      id: '4',
      name: 'Kawasaki Ninja H2',
      brand: 'Kawasaki',
      price: 29999,
      category: 'Sport',
      imageUrl: 'assets/motorcycles/kawasaki_h2.jpg',
      description: 'The Kawasaki Ninja H2 is a supercharged sport bike that delivers incredible power and acceleration with cutting-edge technology.',
      specifications: const BikeSpecifications(
        engine: '998cc Inline-4 Supercharged',
        power: '228 hp',
        torque: '104 lb-ft',
        transmission: '6-speed',
        weight: '476 lbs',
        fuelCapacity: '4.5 gallons',
      ),
      stock: 3,
      isFeatured: true,
      rating: 4.9,
      reviews: [
        Review(
          userId: 'user5',
          userName: 'Kawasaki King',
          rating: 5,
          comment: 'The supercharger sound is absolutely amazing!',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
  ];

  static List<Bike> getFeaturedBikes() {
    return allBikes.where((bike) => bike.isFeatured).toList();
  }

  static Bike? getBikeById(String id) {
    try {
      return allBikes.firstWhere((bike) => bike.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Bike> getBikesByCategory(String category) {
    return allBikes.where((bike) => bike.category.toLowerCase() == category.toLowerCase()).toList();
  }

  static List<Bike> getAllBikes() {
    return allBikes;
  }
}

// Accessories data
class Accessory {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final int stock;

  const Accessory({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.stock,
  });
}

class AccessoryData {
  static final List<Accessory> allAccessories = [
    Accessory(
      id: 'acc1',
      name: 'AGV Pista GP RR Helmet',
      category: 'Helmet',
      price: 899,
      imageUrl: 'assets/accessories/helmet.jpg',
      description: 'Premium racing helmet with advanced aerodynamics and safety features.',
      stock: 15,
    ),
    Accessory(
      id: 'acc2',
      name: 'Alpinestars GP Pro Gloves',
      category: 'Gloves',
      price: 299,
      imageUrl: 'assets/accessories/gloves.jpg',
      description: 'Professional racing gloves with superior grip and protection.',
      stock: 25,
    ),
    Accessory(
      id: 'acc3',
      name: 'Dainese Super Speed Jacket',
      category: 'Jacket',
      price: 1299,
      imageUrl: 'assets/accessories/jacket.jpg',
      description: 'Premium leather racing jacket with advanced protection systems.',
      stock: 10,
    ),
    Accessory(
      id: 'acc4',
      name: 'Sidi Mag-1 Racing Boots',
      category: 'Boots',
      price: 499,
      imageUrl: 'assets/accessories/boots.jpg',
      description: 'Professional racing boots with superior ankle protection and grip.',
      stock: 20,
    ),
  ];

  static List<Accessory> getAccessoriesByCategory(String category) {
    return allAccessories.where((acc) => acc.category.toLowerCase() == category.toLowerCase()).toList();
  }

  static List<Accessory> getAllAccessories() {
    return allAccessories;
  }
} 