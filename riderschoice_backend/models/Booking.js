const mongoose = require("mongoose");

const bookingSchema = new mongoose.Schema({
  userId: { type: String, required: true }, // Add userId field
  packageId: { type: mongoose.Schema.Types.ObjectId, ref: "Package", required: true },
  packageName: { type: String, required: true }, // Add packageName for easier access
  quantity: { type: Number, required: true, min: 1 }, // Rename tickets to quantity
  totalAmount: { type: Number, required: true }, // Add totalAmount
  fullName: { type: String, required: true },
  email: { type: String, required: true },
  phone: { type: String, required: true },
  pickupLocation: { type: String },
  paymentMethod: { type: String, enum: ["credit-card", "debit-card", "upi", "paypal"], required: true },
  status: { type: String, enum: ["pending", "confirmed", "cancelled"], default: "pending" },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("Booking", bookingSchema);
