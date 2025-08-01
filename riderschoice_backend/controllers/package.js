const Package = require("../models/Package");

// Create a new bike
exports.createPackage = async (req, res) => {
  try {
    const { 
      title, 
      description, 
      price, 
      stockAvailable, 
      category,
      cc,
      modelYear,
      mileage,
      fuelType,
      transmission,
      color,
      brand
    } = req.body;
    const image = req.file ? req.file.filename : null;

    if (!title || !description || !price || !category) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    let processedStockAvailable = [];
    if (stockAvailable) {
      try {
        const parsedStock = JSON.parse(stockAvailable);
        processedStockAvailable = parsedStock.filter(stock => stock && stock.trim() !== "");
      } catch (error) {
        console.error("Error parsing stockAvailable:", error);
        processedStockAvailable = [];
      }
    }

    const newPackage = new Package({
      title,
      description,
      price: Number(price),
      image: image || "default-package.jpg",
      stockAvailable: processedStockAvailable,
      category,
      // New bike-specific fields
      cc: cc ? Number(cc) : undefined,
      modelYear: modelYear ? Number(modelYear) : undefined,
      mileage,
      fuelType,
      transmission,
      color,
      brand,
    });

    const savedPackage = await newPackage.save();
    res.status(201).json({
      success: true,
      message: "Bike created successfully",
      data: savedPackage,
    });
  } catch (error) {
    console.error("Error creating bike:", error);
    res.status(500).json({ error: error.message });
  }
};


// Get all packages
exports.getAllPackages = async (req, res) => {
  try {
    const packages = await Package.find();
    res.status(200).json(packages);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get a single package by ID
exports.getPackageById = async (req, res) => {
  try {
    const packageData = await Package.findById(req.params.id);
    if (!packageData) return res.status(404).json({ message: "Bike not found" });
    res.status(200).json(packageData);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update a package
exports.updatePackage = async (req, res) => {
  try {
    const { 
      title, 
      description, 
      price, 
      stockAvailable, 
      category,
      cc,
      modelYear,
      mileage,
      fuelType,
      transmission,
      color,
      brand
    } = req.body;

    // Process stockAvailable if provided
    let processedStockAvailable = undefined;
    if (stockAvailable) {
      try {
        const parsedStock = JSON.parse(stockAvailable);
        processedStockAvailable = parsedStock.filter(stock => stock && stock.trim() !== "");
      } catch (error) {
        console.error("Error parsing stockAvailable:", error);
        processedStockAvailable = [];
      }
    }

    // Prepare update data
    const updateData = {
      title,
      description,
      price: price ? Number(price) : undefined,
      category,
      cc: cc ? Number(cc) : undefined,
      modelYear: modelYear ? Number(modelYear) : undefined,
      mileage,
      fuelType,
      transmission,
      color,
      brand,
    };

    // Add stockAvailable if processed
    if (processedStockAvailable !== undefined) {
      updateData.stockAvailable = processedStockAvailable;
    }

    // Remove undefined values
    Object.keys(updateData).forEach(key => {
      if (updateData[key] === undefined) {
        delete updateData[key];
      }
    });

    const updatedPackage = await Package.findByIdAndUpdate(req.params.id, updateData, { new: true });
    if (!updatedPackage) return res.status(404).json({ message: "Bike not found" });
    
    res.status(200).json({
      success: true,
      message: "Bike updated successfully",
      data: updatedPackage
    });
  } catch (error) {
    console.error("Error updating bike:", error);
    res.status(500).json({ error: error.message });
  }
};

// Delete a package
exports.deletePackage = async (req, res) => {
  try {
    const deletedPackage = await Package.findByIdAndDelete(req.params.id);
    if (!deletedPackage) return res.status(404).json({ message: "Bike not found" });
    res.status(200).json({ message: "Bike deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
