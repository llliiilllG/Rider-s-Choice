const Bike = require('../models/Bike');

// Get all bikes
exports.getAllBikes = async (req, res) => {
  try {
    const bikes = await Bike.find();
    res.json(bikes);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get featured bikes
exports.getFeaturedBikes = async (req, res) => {
  try {
    const bikes = await Bike.find({ isFeatured: true });
    res.json(bikes);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get bike by ID
exports.getBikeById = async (req, res) => {
  try {
    const bike = await Bike.findById(req.params.id);
    if (!bike) {
      return res.status(404).json({ error: 'Bike not found' });
    }
    res.json(bike);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Create new bike (admin only)
exports.createBike = async (req, res) => {
  try {
    const bike = new Bike(req.body);
    await bike.save();
    res.status(201).json(bike);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Update bike (admin only)
exports.updateBike = async (req, res) => {
  try {
    const bike = await Bike.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    if (!bike) {
      return res.status(404).json({ error: 'Bike not found' });
    }
    res.json(bike);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Delete bike (admin only)
exports.deleteBike = async (req, res) => {
  try {
    const bike = await Bike.findByIdAndDelete(req.params.id);
    if (!bike) {
      return res.status(404).json({ error: 'Bike not found' });
    }
    res.json({ message: 'Bike deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Add review to bike
exports.addReview = async (req, res) => {
  try {
    const bike = await Bike.findById(req.params.id);
    if (!bike) {
      return res.status(404).json({ error: 'Bike not found' });
    }

    const review = {
      user: req.user._id,
      rating: req.body.rating,
      comment: req.body.comment
    };

    bike.reviews.push(review);
    
    // Update average rating
    const totalRating = bike.reviews.reduce((sum, review) => sum + review.rating, 0);
    bike.rating = totalRating / bike.reviews.length;

    await bike.save();
    res.json(bike);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get bikes by category
exports.getBikesByCategory = async (req, res) => {
  try {
    const bikes = await Bike.find({ category: req.params.category });
    res.json(bikes);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}; 