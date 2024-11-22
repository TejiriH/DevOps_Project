// import React from 'react';
// import ProductList from './components/ProductList';
// import Login from './components/Login';
// import OrderPlacement from './components/OrderPlacement';

// function App() {
//   return (
//     <div>
//       <h1>E-Commerce Platform</h1>
//       <Login />
//       <ProductList />
//       <OrderPlacement />
//     </div>
//   );
// }

// export default App;

// src/app.js
const express = require('express');
const app = express();

// Middleware to handle JSON requests
app.use(express.json());

// Route for the root endpoint
app.get('/', (req, res) => {
  res.status(200).send('Welcome');
});

// Route to get the list of products
app.get('/api/products', (req, res) => {
  try {
    // Simulated product data (you can replace this with actual DB logic if needed)
    const products = [
      { id: 1, name: 'Product 1' },
      { id: 2, name: 'Product 2' },
    ];
    
    // Log the products data
    console.log('Products:', products);
    
    // Respond with a 200 status and the products array
    res.status(200).json(products);
  } catch (error) {
    // Log the error if one occurs
    console.error('Error occurred in /api/products route:', error);
    
    // Send a 500 error response
    res.status(500).json({ message: "Internal Server Error" });
  }
});

// Assuming you're exporting the app for use in the test
module.exports = app;


// Optionally, if you want to start the server in app.js, use this
// if (require.main === module) {
//   app.listen(3000, () => console.log('Server running on port 3000'));
// }
