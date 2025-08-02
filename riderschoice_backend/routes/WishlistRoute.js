const express = require("express");
const { addToWishlist, removeFromWishlist, getWishlist,getWishlistCount,deleteWishlistItem } = require("../controllers/WishlistController");
const { protect } = require("../middleware/auth"); // Middleware for authentication

const router = express.Router();

// Demo routes without authentication for testing
router.post("/add", addToWishlist);
router.delete("/remove/:packageId", removeFromWishlist);
router.get("/", getWishlist);
router.get("/count", getWishlistCount);
router.delete("/delete/:packageId", deleteWishlistItem);

// Test route to verify the endpoint is accessible
router.get("/test", (req, res) => {
  res.json({ message: "Wishlist API is working!", timestamp: new Date().toISOString() });
});

// Protected routes (uncomment when authentication is implemented)
// router.post("/add", protect, addToWishlist);
// router.delete("/remove/:packageId", protect, removeFromWishlist);
// router.get("/", protect, getWishlist);
// router.get("/count", protect, getWishlistCount);
// router.delete("/delete/:packageId", protect, deleteWishlistItem);


module.exports = router;
