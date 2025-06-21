const express = require('express');
const router = express.Router();
const bikeController = require('../controllers/bikeController');
const { auth, adminAuth } = require('../middleware/auth');

// Public routes
router.get('/', bikeController.getAllBikes);
router.get('/featured', bikeController.getFeaturedBikes);
router.get('/category/:category', bikeController.getBikesByCategory);
router.get('/:id', bikeController.getBikeById);

// Protected routes
router.post('/:id/reviews', auth, bikeController.addReview);

// Admin routes
router.post('/', adminAuth, bikeController.createBike);
router.put('/:id', adminAuth, bikeController.updateBike);
router.delete('/:id', adminAuth, bikeController.deleteBike);

module.exports = router; 