// import { render, screen, waitFor } from '@testing-library/react';
// import ProductList from './ProductList'; // Adjust path as necessary
// import ErrorBoundary from './ErrorBoundary'; // Assuming ErrorBoundary is in the same folder
// import axios from 'axios';
// import { BrowserRouter } from 'react-router-dom';

// // Mock the axios module
// jest.mock('axios');
// import axios from 'axios';

// describe('ProductList Component', () => {
//   const mockProducts = [
//     { id: 1, name: 'Laptop', price: 1000 },
//     { id: 2, name: 'Phone', price: 500 },
//   ];

//   afterEach(() => {
//     jest.clearAllMocks(); // Clear any mocks between tests to avoid conflicts
//   });

//   test('renders product list from backend', async () => {
//     // Mock axios to resolve with product data
//     axios.get.mockResolvedValueOnce({ data: mockProducts });

//     render(
//       <BrowserRouter>
//         <ErrorBoundary>
//           <ProductList />
//         </ErrorBoundary>
//       </BrowserRouter>
//     );

//     // Verify loading state
//     expect(screen.getByText(/Loading.../i)).toBeInTheDocument();

//     // Wait for product data to render
//     await waitFor(() => {
//       expect(screen.getByText(/Laptop/i)).toBeInTheDocument();
//       expect(screen.getByText(/Phone/i)).toBeInTheDocument();
//     });
//   });

//   test('handles API error gracefully', async () => {
//     // Mock axios to reject with an error
//     axios.get.mockRejectedValueOnce(new Error('Failed to fetch products'));

//     render(
//       <BrowserRouter>
//         <ErrorBoundary>
//           <ProductList />
//         </ErrorBoundary>
//       </BrowserRouter>
//     );

//     // Verify loading state
//     expect(screen.getByText(/Loading.../i)).toBeInTheDocument();

//     // Wait for the error message to render
//     await waitFor(() => {
//       expect(screen.getByText(/Failed to fetch products/i)).toBeInTheDocument(); // Error handled in ProductList
//     });
//   });

//   test('displays fallback UI from ErrorBoundary on critical error', async () => {
//     // Mock axios to throw an unexpected error
//     axios.get.mockImplementationOnce(() => {
//       throw new Error('Critical error');
//     });

//     render(
//       <BrowserRouter>
//         <ErrorBoundary>
//           <ProductList />
//         </ErrorBoundary>
//       </BrowserRouter>
//     );

//     // Verify loading state
//     expect(screen.getByText(/Loading.../i)).toBeInTheDocument();

//     // Wait for ErrorBoundary fallback UI
//     await waitFor(() => {
//       expect(screen.getByText(/Something went wrong/i)).toBeInTheDocument();
//     });
//   });
// });

// tests/ProductList.test.js

const request = require('supertest');
const app = require('../src/App'); // Assuming your Express app is in src/app.js

describe('GET /products', () => {
  it('should return a list of products', async () => {
    const response = await request(app).get('/api/products');
    
    expect(response.status).toBe(200);
    expect(response.body).toBeInstanceOf(Array);
    expect(response.body.length).toBeGreaterThan(0);
  });
});
