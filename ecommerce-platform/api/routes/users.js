// routes/users.js
const express = require('express');
const router = express.Router();

// Example route for users
router.get('/', (req, res) => {
  res.status(200).json([{ id: 1, name: 'User 1' }]);
});

module.exports = router;
