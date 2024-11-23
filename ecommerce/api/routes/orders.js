// routes/orders.js
const express = require('express');
const router = express.Router();

// Example route for orders
router.get('/', (req, res) => {
  res.status(200).json([{ id: 1, product: 'Product 1', user: 'User 1' }]);
});

module.exports = router;
