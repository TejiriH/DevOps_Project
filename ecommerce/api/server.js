const express = require('express');
const path = require('path');
const products = require('./routes/products'); // Modularized routes
const users = require('./routes/users');
const orders = require('./routes/orders');

const app = express();

// Middleware
app.use(express.json());

// API Routes
app.use('/api/products', products);
app.use('/api/users', users);
app.use('/api/orders', orders);

// Root route for the application
app.get('/', (req, res) => {
    res.status(200).send('Welcome to the E-commerce Application');
  });

// Serve React build files in production
if (process.env.NODE_ENV === 'production') {
  app.use(express.static(path.join(__dirname, '../webapp/build')));
  app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '../webapp/build', 'index.html'));
  });
}

// Export the app for testing or use in other modules
module.exports = app;

// Start the server only if this script is run directly
if (require.main === module) {
  const PORT = process.env.PORT || 5000;
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}





