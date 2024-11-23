// routes/products.js
const express = require('express');
const router = express.Router();

// Simulated product data (replace with database queries if needed)
const products = [
  { id: 1, name: 'Product 1', price: 10.0 },
  { id: 2, name: 'Product 2', price: 20.0 },
];

// Route to get all products
router.get('/', (req, res) => {
  try {
    res.status(200).json(products);
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

// Export the router to be used in server.js
module.exports = router;

