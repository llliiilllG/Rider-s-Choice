import '../domain/entities/bike.dart';
import 'models/bike_model.dart';

class BikeData {
  static List<Bike> getAllBikes() {
    return [
      Bike(
        id: 'b1',
        name: 'Ducati Panigale V4',
        brand: 'Ducati',
        price: 24999.0,
        category: 'Superbike',
        imageUrl: 'https://images.ctfassets.net/x7j9qwvpvr5s/6QwO5jM90F6v6p9tfRVK8A/7e2e2c2e7e2e2c2e7e2e2c2e7e2e2c2e/ducati-panigale-v4.jpg',
        description: 'The most powerful production Ducati motorcycle ever.',
        specifications: BikeSpecifications(
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
        reviews: [],
      ),
      Bike(
        id: 'b2',
        name: 'Yamaha YZF-R1',
        brand: 'Yamaha',
        price: 17999.0,
        category: 'Superbike',
        imageUrl: 'https://cdn.yamaha-motor.eu/prod/product-assets/2022/YZF1000D/2022-Yamaha-YZF1000D-EU-Icon_Blue-360-Degrees-001-03.jpg',
        description: 'Legendary superbike with MotoGP technology.',
        specifications: BikeSpecifications(
          engine: '998cc Inline-4',
          power: '200 hp',
          torque: '83 lb-ft',
          transmission: '6-speed',
          weight: '448 lbs',
          fuelCapacity: '4.5 gallons',
        ),
        stock: 8,
        isFeatured: true,
        rating: 4.7,
        reviews: [],
      ),
      Bike(
        id: 'b3',
        name: 'BMW S1000RR',
        brand: 'BMW',
        price: 18995.0,
        category: 'Superbike',
        imageUrl: 'https://www.bmw-motorrad.com/content/dam/bmwmotorradnsc/marketDE/bikes/sport/s1000rr/2023/teaser-bmw-s1000rr-2023.jpg.asset.1673348578577.jpg',
        description: 'Cutting-edge superbike with advanced electronics.',
        specifications: BikeSpecifications(
          engine: '999cc Inline-4',
          power: '205 hp',
          torque: '83 lb-ft',
          transmission: '6-speed',
          weight: '434 lbs',
          fuelCapacity: '4.4 gallons',
        ),
        stock: 6,
        isFeatured: true,
        rating: 4.6,
        reviews: [],
      ),
      Bike(
        id: 'b4',
        name: 'Kawasaki Ninja H2',
        brand: 'Kawasaki',
        price: 29999.0,
        category: 'Superbike',
        imageUrl: 'https://www.kawasaki.com/Content/Uploads/Products/2022_NinjaH2_CandyFlatBlazedGreen_001.jpg',
        description: 'Supercharged hyperbike with unmatched performance.',
        specifications: BikeSpecifications(
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
        reviews: [],
      ),
      Bike(
        id: 'b5',
        name: 'Honda CBR1000RR-R Fireblade',
        brand: 'Honda',
        price: 22999.0,
        category: 'Superbike',
        imageUrl: 'https://powersports.honda.com/-/media/Products/2022/CBR1000RRR/2022/CBR1000RRR_Superbike_01.jpg',
        description: 'Track-focused superbike with racing pedigree.',
        specifications: BikeSpecifications(
          engine: '999cc Inline-4',
          power: '215 hp',
          torque: '83 lb-ft',
          transmission: '6-speed',
          weight: '443 lbs',
          fuelCapacity: '4.3 gallons',
        ),
        stock: 4,
        isFeatured: false,
        rating: 4.5,
        reviews: [],
      ),
      Bike(
        id: 'b6',
        name: 'Suzuki GSX-R1000R',
        brand: 'Suzuki',
        price: 16999.0,
        category: 'Superbike',
        imageUrl: 'https://www.suzukicycles.com/-/media/project/suzuki/suzukicycles/images/products/2022/gsxr1000r/2022-gsxr1000r-m2-ysf-right.jpg',
        description: 'Balanced superbike with legendary reliability.',
        specifications: BikeSpecifications(
          engine: '999cc Inline-4',
          power: '199 hp',
          torque: '86 lb-ft',
          transmission: '6-speed',
          weight: '445 lbs',
          fuelCapacity: '4.2 gallons',
        ),
        stock: 7,
        isFeatured: false,
        rating: 4.4,
        reviews: [],
      ),
      Bike(
        id: 'b7',
        name: 'Aprilia RSV4 1100 Factory',
        brand: 'Aprilia',
        price: 25999.0,
        category: 'Superbike',
        imageUrl: 'https://www.aprilia.com/content/dam/aprilia/markets/aprilia_com/models/rsv4/2022/gallery/Aprilia-RSV4-1100-Factory-2022-01.jpg',
        description: 'Italian superbike with V4 power and style.',
        specifications: BikeSpecifications(
          engine: '1078cc V4',
          power: '217 hp',
          torque: '92 lb-ft',
          transmission: '6-speed',
          weight: '438 lbs',
          fuelCapacity: '4.9 gallons',
        ),
        stock: 2,
        isFeatured: false,
        rating: 4.7,
        reviews: [],
      ),
      Bike(
        id: 'b8',
        name: 'MV Agusta F4',
        brand: 'MV Agusta',
        price: 34999.0,
        category: 'Superbike',
        imageUrl: 'https://www.mvagusta.com/sites/default/files/styles/large/public/2021-01/F4%20RC%20MY20%20-%20Gallery%20%281%29.jpg',
        description: 'Exotic Italian superbike with stunning design.',
        specifications: BikeSpecifications(
          engine: '998cc Inline-4',
          power: '212 hp',
          torque: '85 lb-ft',
          transmission: '6-speed',
          weight: '423 lbs',
          fuelCapacity: '4.4 gallons',
        ),
        stock: 1,
        isFeatured: false,
        rating: 4.9,
        reviews: [],
      ),
      Bike(
        id: 'b9',
        name: 'Harley-Davidson Street Glide',
        brand: 'Harley-Davidson',
        price: 21999.0,
        category: 'Cruiser',
        imageUrl: 'https://www.harley-davidson.com/content/dam/h-d/images/motorcycles/my21/touring/street-glide/2021-street-glide-motorcycle.jpg',
        description: 'Classic American cruiser with modern tech and comfort.',
        specifications: BikeSpecifications(
          engine: '1746cc V-Twin',
          power: '90 hp',
          torque: '111 lb-ft',
          transmission: '6-speed',
          weight: '796 lbs',
          fuelCapacity: '6 gallons',
        ),
        stock: 3,
        isFeatured: true,
        rating: 4.7,
        reviews: [],
      ),
      Bike(
        id: 'b10',
        name: 'Royal Enfield Interceptor 650',
        brand: 'Royal Enfield',
        price: 6999.0,
        category: 'Naked',
        imageUrl: 'https://www.royalenfield.com/content/dam/royal-enfield/usa/motorcycles/interceptor-650/gallery/01.jpg',
        description: 'Retro-styled twin with modern reliability.',
        specifications: BikeSpecifications(
          engine: '648cc Parallel-Twin',
          power: '47 hp',
          torque: '38 lb-ft',
          transmission: '6-speed',
          weight: '445 lbs',
          fuelCapacity: '3.6 gallons',
        ),
        stock: 10,
        isFeatured: false,
        rating: 4.3,
        reviews: [],
      ),
      Bike(
        id: 'b11',
        name: 'KTM 1290 Super Duke R',
        brand: 'KTM',
        price: 18999.0,
        category: 'Naked',
        imageUrl: 'https://www.ktm.com/content/dam/websites/ktm-com/motorrad/naked/1290-super-duke-r/gallery/2022/2022-ktm-1290-super-duke-r-1.jpg',
        description: 'The "Beast"—raw power and aggressive styling.',
        specifications: BikeSpecifications(
          engine: '1301cc V-Twin',
          power: '180 hp',
          torque: '103 lb-ft',
          transmission: '6-speed',
          weight: '430 lbs',
          fuelCapacity: '4.2 gallons',
        ),
        stock: 5,
        isFeatured: true,
        rating: 4.8,
        reviews: [],
      ),
      Bike(
        id: 'b12',
        name: 'Triumph Tiger 900 Rally',
        brand: 'Triumph',
        price: 14999.0,
        category: 'Adventure',
        imageUrl: 'https://images.triumphmotorcycles.co.uk/media-library/images/bikes/adventure/tiger-900/2021/21my-tiger-900-rally-pro-matt-khaki-green-rhs-3-4.jpg',
        description: 'Versatile adventure bike for on and off-road.',
        specifications: BikeSpecifications(
          engine: '888cc Inline-3',
          power: '94 hp',
          torque: '64 lb-ft',
          transmission: '6-speed',
          weight: '432 lbs',
          fuelCapacity: '5.3 gallons',
        ),
        stock: 6,
        isFeatured: false,
        rating: 4.6,
        reviews: [],
      ),
    ];
  }

  static List<Bike> getFeaturedBikes() {
    return getAllBikes().where((bike) => bike.isFeatured).toList();
  }

  static Bike? getBikeById(String id) {
    try {
      return getAllBikes().firstWhere((bike) => bike.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Bike> getBikesByCategory(String category) {
    return getAllBikes().where((bike) => bike.category.toLowerCase() == category.toLowerCase()).toList();
  }
}

// Accessories data
final List<Map<String, dynamic>> accessories = [
  {
    'id': 'a1',
    'name': 'Racing Helmet',
    'price': 199.99,
    'imageUrl': 'assets/accessories/helmet.jpg',
    'description': 'Premium full-face helmet for maximum safety.'
  },
  {
    'id': 'a2',
    'name': 'Leather Jacket',
    'price': 249.99,
    'imageUrl': 'assets/accessories/jacket.jpg',
    'description': 'Stylish and protective leather riding jacket.'
  },
  {
    'id': 'a3',
    'name': 'Riding Gloves',
    'price': 49.99,
    'imageUrl': 'assets/accessories/gloves.jpg',
    'description': 'Comfortable gloves with superior grip.'
  },
  {
    'id': 'a4',
    'name': 'Riding Boots',
    'price': 129.99,
    'imageUrl': 'assets/accessories/boots.jpg',
    'description': 'Durable boots for all-weather riding.'
  },
  // New accessories with real image URLs
  {
    'id': 'a5',
    'name': 'Bluetooth Intercom',
    'price': 89.99,
    'imageUrl': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
    'description': 'Stay connected with your group on the road.'
  },
  {
    'id': 'a6',
    'name': 'Motorcycle Cover',
    'price': 39.99,
    'imageUrl': 'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?auto=format&fit=crop&w=400&q=80',
    'description': 'Protect your bike from dust and rain.'
  },
  {
    'id': 'a7',
    'name': 'Tank Bag',
    'price': 59.99,
    'imageUrl': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
    'description': 'Convenient storage for your essentials.'
  },
  {
    'id': 'a8',
    'name': 'Action Camera Mount',
    'price': 19.99,
    'imageUrl': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
    'description': 'Capture your rides from every angle.'
  },
]; 