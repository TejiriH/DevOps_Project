const express = require('express');
const app = express();
const products = require('./routes/products');
const users = require('./routes/users');
const orders = require('./routes/orders');

app.use(express.json());

app.use('/api/products', products);
app.use('/api/users', users);
app.use('/api/orders', orders);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`API running on port ${PORT}`));
