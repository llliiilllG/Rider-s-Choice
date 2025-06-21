const mongoose = require('mongoose');
const Bike = require('../models/Bike');
const User = require('../models/User');
const bcrypt = require('bcryptjs');

const sampleBikes = [
  {
    name: 'Ducati Panigale V4',
    brand: 'Ducati',
    price: 24999,
    category: 'Sport',
    imageUrl: 'assets/motorcycles/ducati_panigale.jpg',
    description: 'The Ducati Panigale V4 is the first Ducati production bike to use a 4-cylinder engine. It features advanced electronics, aerodynamic design, and incredible performance.',
    specifications: {
      engine: '1103cc V4',
      power: '214 hp',
      torque: '91.5 lb-ft',
      transmission: '6-speed',
      weight: '430 lbs',
      fuelCapacity: '4.2 gallons'
    },
    stock: 5,
    isFeatured: true,
    rating: 4.8,
    reviews: []
  },
  {
    name: 'BMW S1000RR',
    brand: 'BMW',
    price: 18995,
    category: 'Sport',
    imageUrl: 'assets/motorcycles/bmw_s1000rr.jpg',
    description: 'The BMW S1000RR is a high-performance sport bike with advanced electronics, dynamic traction control, and race-inspired design.',
    specifications: {
      engine: '999cc Inline-4',
      power: '205 hp',
      torque: '83 lb-ft',
      transmission: '6-speed',
      weight: '434 lbs',
      fuelCapacity: '4.4 gallons'
    },
    stock: 8,
    isFeatured: true,
    rating: 4.7,
    reviews: []
  },
  {
    name: 'Yamaha YZF-R1',
    brand: 'Yamaha',
    price: 17999,
    category: 'Sport',
    imageUrl: 'assets/motorcycles/yamaha_r1.jpg',
    description: 'The Yamaha YZF-R1 is a superbike with MotoGP-inspired technology, including a crossplane crankshaft engine and advanced electronics.',
    specifications: {
      engine: '998cc Inline-4',
      power: '200 hp',
      torque: '83 lb-ft',
      transmission: '6-speed',
      weight: '448 lbs',
      fuelCapacity: '4.5 gallons'
    },
    stock: 6,
    isFeatured: true,
    rating: 4.6,
    reviews: []
  },
  {
    name: 'Kawasaki Ninja H2',
    brand: 'Kawasaki',
    price: 29999,
    category: 'Sport',
    imageUrl: 'assets/motorcycles/kawasaki_h2.jpg',
    description: 'The Kawasaki Ninja H2 is a supercharged sport bike that delivers incredible power and acceleration with cutting-edge technology.',
    specifications: {
      engine: '998cc Inline-4 Supercharged',
      power: '228 hp',
      torque: '104 lb-ft',
      transmission: '6-speed',
      weight: '476 lbs',
      fuelCapacity: '4.5 gallons'
    },
    stock: 3,
    isFeatured: true,
    rating: 4.9,
    reviews: []
  }
];

const seedDatabase = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/riders-choice');
    console.log('Connected to MongoDB');

    // Clear existing data
    await Bike.deleteMany({});
    await User.deleteMany({});
    console.log('Cleared existing data');

    // Insert sample bikes
    const bikes = await Bike.insertMany(sampleBikes);
    console.log(`Inserted ${bikes.length} bikes`);

    // Create admin user
    const hashedPassword = await bcrypt.hash('admin123', 10);
    const adminUser = new User({
      name: 'Admin User',
      email: 'admin@riderschoice.com',
      password: hashedPassword,
      role: 'admin'
    });
    await adminUser.save();
    console.log('Created admin user');

    // Create sample user
    const userPassword = await bcrypt.hash('user123', 10);
    const sampleUser = new User({
      name: 'John Doe',
      email: 'john@example.com',
      password: userPassword,
      role: 'user'
    });
    await sampleUser.save();
    console.log('Created sample user');

    console.log('Database seeded successfully!');
    console.log('\nSample credentials:');
    console.log('Admin: admin@riderschoice.com / admin123');
    console.log('User: john@example.com / user123');

    process.exit(0);
  } catch (error) {
    console.error('Error seeding database:', error);
    process.exit(1);
  }
};

// Run seed if this file is executed directly
if (require.main === module) {
  require('dotenv').config();
  seedDatabase();
}

module.exports = seedDatabase; 