const Review = require('../models/Review');
const Package = require('../models/Package');

const findAll = async (req, res) => {
    try {
        const reviews = await Review.find().populate("packageId", "title brand");
        res.status(200).json(reviews);
    } catch (e) {
        console.error('Error fetching reviews:', e);
        res.status(500).json({ error: e.message });
    }

}
const save = async (req, res) => {
    try {
        const reviews = new Review(req.body);
        await reviews.save();
        res.status(201).json(reviews)
    } catch (e) {
        console.error('Error saving review:', e);
        res.status(500).json({ error: e.message });
    }

}
const findById = async (req, res) => {
    try {
        const review = await Review.findById(req.params.id);
        res.status(200).json(review)
    } catch (e) {
        console.error('Error finding review:', e);
        res.status(500).json({ error: e.message });
    }


}
const deleteById = async (req, res) => {
    try {
        const review = await Review.findByIdAndDelete(req.params.id);
        res.status(200).json("data Deleted")
    } catch (e) {
        console.error('Error deleting review:', e);
        res.status(500).json({ error: e.message });
    }


}
const update = async (req, res) => {
    try {
        const review = await Review.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.status(201).json(review)
    } catch (e) {
        console.error('Error updating review:', e);
        res.status(500).json({ error: e.message });
    }


}

module.exports = {
    findAll,
    save,
    findById,
    deleteById,
    update

}