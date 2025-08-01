const express = require("express");
const router = express.Router();
const { protect, authorize } = require("../middleware/auth");
const upload = require("../middleware/uploads");

const {
    getCustomers,
    getCustomer,
    register,
    login,
    uploadImage,
    updateCustomer
} = require("../controllers/customer");

// Custom middleware for optional file upload
const optionalUpload = (req, res, next) => {
    upload.single("profilePicture")(req, res, (err) => {
        if (err) {
            // If there's an error but no file was uploaded, continue without file
            if (err.code === 'LIMIT_FILE_SIZE' || err.message === 'File format not supported.') {
                return res.status(400).json({ message: err.message });
            }
            // For other errors, continue without file
            req.file = undefined;
        }
        next();
    });
};

// Routes
router.post("/register", optionalUpload, register);
router.post("/login", login);

// Restrict these routes to logged-in users
router.get("/getAllCustomers", protect, authorize("admin"), getCustomers);
router.get("/getCustomer/:id", protect, authorize("admin", "customer"), getCustomer);
router.put("/updateCustomer/:id", protect, authorize("admin", "customer"), upload.single("profilePicture"), updateCustomer);
router.post("/uploadImage", protect, authorize("admin", "customer"), upload.single("profilePicture"), uploadImage);

module.exports = router;