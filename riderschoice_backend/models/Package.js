const mongoose = require("mongoose");

const packageSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    description: { type: String, required: true },
    price: { type: Number, required: true },
    image: { type: String, default: "default-package.jpg" },
    stockAvailable: [{ type: String }],
    category: { type: String, required: true, enum: ["Adventure", "Luxury", "Budget", "Sports", "Cruiser"] },
    // New bike-specific fields
    cc: { type: Number },
    modelYear: { type: Number },
    mileage: { type: String },
    fuelType: { type: String, enum: ["Petrol", "Diesel", "Electric", "Hybrid"], default: "Petrol" },
    transmission: { type: String, enum: ["Manual", "Automatic", "CVT"], default: "Manual" },
    color: { type: String },
    brand: { type: String },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Package", packageSchema);
