const express = require('express');
const router = express.Router();
const Bike = require('../models/Bike');
const auth = require('../middleware/auth');

// Get all bikes
router.get('/', async (req, res) => {
  try {
    const bikes = await Bike.find();
    res.json(bikes);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Get featured bikes
router.get('/featured', async (req, res) => {
  try {
    const bikes = await Bike.find({ isFeatured: true });
    res.json(bikes);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Get bike by ID
router.get('/:id', async (req, res) => {
  try {
    const bike = await Bike.findById(req.params.id);
    if (!bike) {
      return res.status(404).json({ message: 'Bike not found' });
    }
    res.json(bike);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Get bikes by category
router.get('/category/:category', async (req, res) => {
  try {
    const bikes = await Bike.find({ category: req.params.category });
    res.json(bikes);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Add a new bike (admin only)
router.post('/', auth, async (req, res) => {
  try {
    const bike = new Bike(req.body);
    const newBike = await bike.save();
    res.status(201).json(newBike);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Update a bike (admin only)
router.put('/:id', auth, async (req, res) => {
  try {
    const bike = await Bike.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!bike) {
      return res.status(404).json({ message: 'Bike not found' });
    }
    res.json(bike);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Delete a bike (admin only)
router.delete('/:id', auth, async (req, res) => {
  try {
    const bike = await Bike.findByIdAndDelete(req.params.id);
    if (!bike) {
      return res.status(404).json({ message: 'Bike not found' });
    }
    res.json({ message: 'Bike deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Add a review to a bike
router.post('/:id/reviews', auth, async (req, res) => {
  try {
    const bike = await Bike.findById(req.params.id);
    if (!bike) {
      return res.status(404).json({ message: 'Bike not found' });
    }

    const review = {
      userId: req.user.id,
      userName: req.user.name,
      rating: req.body.rating,
      comment: req.body.comment
    };

    bike.reviews.push(review);
    
    // Update average rating
    const totalRating = bike.reviews.reduce((sum, review) => sum + review.rating, 0);
    bike.rating = totalRating / bike.reviews.length;

    await bike.save();
    res.status(201).json(bike);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

module.exports = router; 