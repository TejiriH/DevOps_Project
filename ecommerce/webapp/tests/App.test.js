// import { render, screen } from '@testing-library/react';
// import { BrowserRouter } from 'react-router-dom';
// import App from '../src/App';
// import React from 'react'; // Add this at the top of your test files


// test('renders without crashing', () => {
//   render(
//     <BrowserRouter>
//       <App />
//     </BrowserRouter>
//   );
//   expect(screen.getByText(/Welcome to My E-Commerce App/i)).toBeInTheDocument(); // Replace with actual text in your app
// });

// test('renders routes correctly', () => {
//   render(
//     <BrowserRouter>
//       <App />
//     </BrowserRouter>
//   );

//   expect(screen.getByText(/Home/i)).toBeInTheDocument(); // Replace with navigation links or default component text
// });


// tests/App.test.js


const request = require('supertest');
const app = require('../src/App'); // Adjust the path if necessary
const http = require('http'); // Required for app.server

let server;

beforeAll((done) => {
  // Start the server before running tests
  server = app.listen(3000, done);
});

afterAll((done) => {
  // Close the server after the tests are complete
  server.close(done);
});

describe('GET /', () => {
  it('should return a 200 status', async () => {
    const response = await request(app).get('/');
    console.log('Response status:', response.status);
    console.log('Response body:', response.body);
    expect(response.status).toBe(200);
    expect(response.text).toContain('Welcome');
  });
});

describe('GET /products', () => {
  it('should return a list of products', async () => {
    const response = await request(app).get('/api/products');
    console.log('Products:', response.body); // Log the response for debugging
    expect(response.status).toBe(200);
    expect(response.body).toBeInstanceOf(Array);
    expect(response.body.length).toBeGreaterThan(0);
  });
});


