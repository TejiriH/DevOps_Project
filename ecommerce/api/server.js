const express = require('express');
const path = require('path');
const products = require('./routes/products'); // Example modularized routes
const users = require('./routes/users');
const orders = require('./routes/orders');

const app = express();

// Middleware
app.use(express.json());

// API routes
app.use('/api/products', products);
app.use('/api/users', users);
app.use('/api/orders', orders);

// Serve React build files in production
if (process.env.NODE_ENV === 'production') {
  app.use(express.static(path.join(__dirname, '../webapp/build')));
  app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '../webapp/build', 'index.html'));
  });
}

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));




