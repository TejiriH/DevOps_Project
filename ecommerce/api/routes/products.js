const express = require('express');
const router = express.Router();

// Mock Data
let products = [
  { id: 1, name: 'Laptop', price: 1000 },
  { id: 2, name: 'Phone', price: 500 },
];

// Get Products
router.get('/', (req, res) => res.json(products));

// Add Product
router.post('/', (req, res) => {
  const newProduct = { id: Date.now(), ...req.body };
  products.push(newProduct);
  res.status(201).json(newProduct);
});

module.exports = router;
