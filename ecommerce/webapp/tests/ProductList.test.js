import { render, screen, waitFor } from '@testing-library/react';
import ProductList from '../components/ProductList';
import axios from 'axios';
import { BrowserRouter } from 'react-router-dom';

jest.mock('axios');

const mockProducts = [
  { id: 1, name: 'Laptop', price: 1000 },
  { id: 2, name: 'Phone', price: 500 },
];

test('renders product list from backend', async () => {
  axios.get.mockResolvedValueOnce({ data: mockProducts });

  render(
    <BrowserRouter>
      <ProductList />
    </BrowserRouter>
  );

  expect(screen.getByText(/Loading.../i)).toBeInTheDocument();

  // Wait for products to load
  await waitFor(() => {
    expect(screen.getByText(/Laptop/i)).toBeInTheDocument();
    expect(screen.getByText(/Phone/i)).toBeInTheDocument();
  });
});

test('handles API error gracefully', async () => {
  axios.get.mockRejectedValueOnce(new Error('Failed to fetch products'));

  render(
    <BrowserRouter>
      <ProductList />
    </BrowserRouter>
  );

  expect(screen.getByText(/Loading.../i)).toBeInTheDocument();

  await waitFor(() => {
    expect(screen.getByText(/Failed to load products/i)).toBeInTheDocument(); // Replace with your error message
  });
});
