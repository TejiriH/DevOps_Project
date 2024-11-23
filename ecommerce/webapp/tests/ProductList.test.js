
// tests/ProductList.test.js

const request = require('supertest');
const app = require('../../api/server'); // Assuming your Express app is in src/app.js

describe('GET /products', () => {
  it('should return a list of products', async () => {
    const response = await request(app).get('/api/products');
    
    expect(response.status).toBe(200);
    expect(response.body).toBeInstanceOf(Array);
    expect(response.body.length).toBeGreaterThan(0);
  });
});
