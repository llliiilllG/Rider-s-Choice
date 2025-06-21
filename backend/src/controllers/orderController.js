const Order = require('../models/Order');
const Bike = require('../models/Bike');

// Create new order
exports.createOrder = async (req, res) => {
  try {
    const { items, shippingAddress, paymentMethod } = req.body;
    
    // Calculate total amount and validate stock
    let totalAmount = 0;
    for (const item of items) {
      const bike = await Bike.findById(item.bike);
      if (!bike) {
        return res.status(404).json({ error: `Bike ${item.bike} not found` });
      }
      if (bike.stock < item.quantity) {
        return res.status(400).json({ error: `Insufficient stock for ${bike.name}` });
      }
      totalAmount += bike.price * item.quantity;
      
      // Update stock
      bike.stock -= item.quantity;
      await bike.save();
    }

    const order = new Order({
      user: req.user._id,
      items,
      totalAmount,
      shippingAddress,
      paymentMethod
    });

    await order.save();

    // Add order to user's orders
    req.user.orders.push(order._id);
    await req.user.save();

    res.status(201).json(order);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get user's orders
exports.getUserOrders = async (req, res) => {
  try {
    const orders = await Order.find({ user: req.user._id })
      .populate('items.bike')
      .sort({ createdAt: -1 });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get order by ID
exports.getOrderById = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate('items.bike');
    
    if (!order) {
      return res.status(404).json({ error: 'Order not found' });
    }

    if (order.user.toString() !== req.user._id.toString() && req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied' });
    }

    res.json(order);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update order status (admin only)
exports.updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({ error: 'Order not found' });
    }

    order.status = status;
    if (status === 'shipped') {
      order.trackingNumber = req.body.trackingNumber;
      order.estimatedDelivery = req.body.estimatedDelivery;
    }

    await order.save();
    res.json(order);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Cancel order
exports.cancelOrder = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({ error: 'Order not found' });
    }

    if (order.user.toString() !== req.user._id.toString()) {
      return res.status(403).json({ error: 'Access denied' });
    }

    if (order.status !== 'pending') {
      return res.status(400).json({ error: 'Cannot cancel order in current status' });
    }

    // Restore stock
    for (const item of order.items) {
      const bike = await Bike.findById(item.bike);
      bike.stock += item.quantity;
      await bike.save();
    }

    order.status = 'cancelled';
    await order.save();
    res.json(order);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}; 