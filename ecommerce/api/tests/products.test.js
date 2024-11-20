const request = require('supertest');
const express = require('express');
const products = require('../routes/products');

const app = express();
app.use(express.json());
app.use('/api/products', products);

describe('Products API', () => {
  it('GET /api/products should return all products', async () => {
    const res = await request(app).get('/api/products');
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  it('POST /api/products should add a new product', async () => {
    const newProduct = { name: 'Tablet', price: 200 };
    const res = await request(app).post('/api/products').send(newProduct);
    expect(res.statusCode).toBe(201);
    expect(res.body.name).toBe('Tablet');
  });
});

