const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  userName: {
    type: String,
    required: true
  },
  rating: {
    type: Number,
    required: true,
    min: 1,
    max: 5
  },
  comment: {
    type: String,
    required: true
  },
  date: {
    type: Date,
    default: Date.now
  }
});

const specificationsSchema = new mongoose.Schema({
  engine: {
    type: String,
    required: true
  },
  power: {
    type: String,
    required: true
  },
  torque: {
    type: String,
    required: true
  },
  transmission: {
    type: String,
    required: true
  },
  weight: {
    type: String,
    required: true
  },
  fuelCapacity: {
    type: String,
    required: true
  }
});

const bikeSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  brand: {
    type: String,
    required: true,
    trim: true
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  category: {
    type: String,
    required: true,
    enum: ['Sport', 'Cruiser', 'Adventure', 'Naked', 'Touring']
  },
  imageUrl: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  specifications: {
    type: specificationsSchema,
    required: true
  },
  stock: {
    type: Number,
    required: true,
    min: 0
  },
  isFeatured: {
    type: Boolean,
    default: false
  },
  rating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5
  },
  reviews: [reviewSchema]
}, {
  timestamps: true
});

module.exports = mongoose.model('Bike', bikeSchema); 