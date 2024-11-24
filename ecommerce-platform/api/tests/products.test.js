const request = require('supertest');
const express = require('express');
const products = require('../routes/products');

const app = express();
app.use(express.json());
app.use('/api/products', products);

test('GET /api/products', async () => {
  const res = await request(app).get('/api/products');
  expect(res.statusCode).toBe(200);
  expect(res.body).toBeInstanceOf(Array);
});
