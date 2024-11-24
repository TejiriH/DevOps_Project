import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { BrowserRouter as Router, Route, Link, Routes } from 'react-router-dom';

// Products Component
function Products() {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    // Fetch products from the API
    axios.get('/api/products')
      .then(response => {
        setProducts(response.data);
      })
      .catch(error => {
        console.error('Error fetching products:', error);
      });
  }, []);

  return (
    <div>
      <h1>Products</h1>
      <ul>
        {products.map(product => (
          <li key={product.id}>{product.name}</li>
        ))}
      </ul>
    </div>
  );
}

// Users Component
function Users() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    // Fetch users from the API
    axios.get('/api/users')
      .then(response => {
        setUsers(response.data);
      })
      .catch(error => {
        console.error('Error fetching users:', error);
      });
  }, []);

  return (
    <div>
      <h1>Users</h1>
      <ul>
        {users.map(user => (
          <li key={user.id}>{user.name}</li>
        ))}
      </ul>
    </div>
  );
}

// Orders Component
function Orders() {
  const [orders, setOrders] = useState([]);

  useEffect(() => {
    // Fetch orders from the API
    axios.get('/api/orders')
      .then(response => {
        setOrders(response.data);
      })
      .catch(error => {
        console.error('Error fetching orders:', error);
      });
  }, []);

  return (
    <div>
      <h1>Orders</h1>
      <ul>
        {orders.map(order => (
          <li key={order.id}>{`Order ${order.id}: ${order.description}`}</li>
        ))}
      </ul>
    </div>
  );
}

// Main App Component with Routing
function App() {
  return (
    <Router>
      <div className="App">
        <nav>
          <Link to="/products">Products</Link>
          <Link to="/users">Users</Link>
          <Link to="/orders">Orders</Link>
        </nav>
        <Routes>
          <Route path="/products" element={<Products />} />
          <Route path="/users" element={<Users />} />
          <Route path="/orders" element={<Orders />} />
          <Route path="/" element={<h1>Welcome to the E-Commerce Application</h1>} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;

