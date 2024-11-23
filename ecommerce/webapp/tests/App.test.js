// tests/App.test.js

const request = require('supertest');
const app = require('../../api/server'); // Adjust the path if necessary
const http = require('http'); // Required for app.server

let server;

beforeAll((done) => {
  // Start the server before running tests
  server = app.listen(3000, () => {
    console.log('Test server is running on port 3000');
    done();
  });
});

afterAll((done) => {
  // Close the server after the tests are complete
  server.close(() => {
    console.log('Test server closed');
    done();
  });
});

describe('Root Route Tests', () => {
  it('GET / should return a 200 status and welcome message', async () => {
    const response = await request(app).get('/');
    console.log('Response status:', response.status);
    console.log('Response body:', response.body);

    // Assertions
    expect(response.status).toBe(200);
    expect(response.text).toContain('Welcome'); // Adjust based on actual content
  });
});

describe('Product API Tests', () => {
  it('GET /api/products should return a list of products', async () => {
    const response = await request(app).get('/api/products');
    console.log('Products:', response.body); // Log the response for debugging

    // Assertions
    expect(response.status).toBe(200);
    expect(Array.isArray(response.body)).toBe(true); // Ensure response is an array
    expect(response.body.length).toBeGreaterThan(0); // Ensure array has at least one product
    expect(response.body[0]).toHaveProperty('id'); // Example property checks, adjust as needed
    expect(response.body[0]).toHaveProperty('name');
  });
});



