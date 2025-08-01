const mongoose = require('mongoose');
const Package = require('./models/Package');
require('dotenv').config({ path: './config/config.env' });

// Connect to MongoDB
mongoose.connect(process.env.LOCAL_DATABASE_URI)
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.error('MongoDB connection error:', err));

const newBikes = [
  {
    title: "Suzuki Gixxer SF",
    description: "The Suzuki Gixxer SF is a premium sport bike featuring a sleek aerodynamic design with full fairing. It comes with a powerful 155cc engine, advanced fuel injection system, and modern styling that makes it perfect for both city commuting and highway cruising.",
    price: 185000,
    category: "Sports",
    cc: 155,
    modelYear: 2024,
    mileage: "45 km/l",
    fuelType: "Petrol",
    transmission: "Manual",
    color: "Silver with Red Accents",
    brand: "Suzuki",
    stockAvailable: ["Available", "In Stock"],
    image: "gixxer-sf.jpg"
  },
  {
    title: "Royal Enfield Classic 350",
    description: "The Royal Enfield Classic 350 is a timeless motorcycle that combines vintage aesthetics with modern engineering. Known for its distinctive thump and retro styling, it features a 349cc engine, comfortable riding position, and premium build quality perfect for long rides.",
    price: 215000,
    category: "Cruiser",
    cc: 349,
    modelYear: 2024,
    mileage: "35 km/l",
    fuelType: "Petrol",
    transmission: "Manual",
    color: "Matte Dark Grey with Copper Accents",
    brand: "Royal Enfield",
    stockAvailable: ["Available", "Limited Stock"],
    image: "classic-350.jpg"
  },
  {
    title: "Honda CRF250L",
    description: "The Honda CRF250L is a versatile dual-sport motorcycle designed for both on-road and off-road adventures. It features a reliable 250cc engine, long-travel suspension, and rugged construction making it ideal for adventure touring and trail riding.",
    price: 450000,
    category: "Adventure",
    cc: 250,
    modelYear: 2024,
    mileage: "40 km/l",
    fuelType: "Petrol",
    transmission: "Manual",
    color: "Red and White",
    brand: "Honda",
    stockAvailable: ["Available", "In Stock"],
    image: "crf250l.jpg"
  },
  {
    title: "KTM Duke 390",
    description: "The KTM Duke 390 is a high-performance naked street bike known for its aggressive styling and powerful performance. It features a 373cc engine, advanced electronics, premium suspension, and lightweight trellis frame for an exhilarating riding experience.",
    price: 380000,
    category: "Sports",
    cc: 373,
    modelYear: 2024,
    mileage: "30 km/l",
    fuelType: "Petrol",
    transmission: "Manual",
    color: "Black with Neon Green Accents",
    brand: "KTM",
    stockAvailable: ["Available", "Premium Stock"],
    image: "duke-390.jpg"
  },
  {
    title: "Bajaj Pulsar NS200",
    description: "The Bajaj Pulsar NS200 is a sporty naked bike that offers excellent performance and value. It features a 200cc engine, digital instrument cluster, LED lighting, and aggressive styling that appeals to young riders looking for performance and style.",
    price: 165000,
    category: "Sports",
    cc: 200,
    modelYear: 2024,
    mileage: "42 km/l",
    fuelType: "Petrol",
    transmission: "Manual",
    color: "Red and Black",
    brand: "Bajaj",
    stockAvailable: ["Available", "In Stock"],
    image: "pulsar-ns200.jpg"
  }
];

async function addBikes() {
  try {
    console.log('Starting to add bikes...');
    
    for (const bikeData of newBikes) {
      // Check if bike already exists
      const existingBike = await Package.findOne({ title: bikeData.title });
      
      if (existingBike) {
        console.log(`Bike "${bikeData.title}" already exists, skipping...`);
        continue;
      }
      
      const newBike = new Package(bikeData);
      const savedBike = await newBike.save();
      console.log(`✅ Added bike: ${savedBike.title}`);
    }
    
    console.log('🎉 All bikes added successfully!');
    
    // Display all bikes
    const allBikes = await Package.find();
    console.log(`\nTotal bikes in database: ${allBikes.length}`);
    allBikes.forEach(bike => {
      console.log(`- ${bike.title} (${bike.brand}) - ₹${bike.price.toLocaleString()}`);
    });
    
  } catch (error) {
    console.error('Error adding bikes:', error);
  } finally {
    mongoose.connection.close();
    console.log('Database connection closed');
  }
}

// Run the script
addBikes(); 