const mongoose = require("mongoose");

const wishlistSchema = new mongoose.Schema({
    customer: {
        type: String, // Changed to String for demo purposes
        required: true,
    },
    packages: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Package", // Assuming your travel package model is named "Package"
        }
    ],
}, { timestamps: true }); // Automatically adds createdAt & updatedAt

module.exports = mongoose.model("Wishlist", wishlistSchema);
