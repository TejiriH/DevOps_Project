import React from 'react';
import ProductList from './components/ProductList';
import Login from './components/Login';
import OrderPlacement from './components/OrderPlacement';

function App() {
  return (
    <div>
      <h1>E-Commerce Platform</h1>
      <Login />
      <ProductList />
      <OrderPlacement />
    </div>
  );
}

export default App;
