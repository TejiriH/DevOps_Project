import { render, screen } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import App from '../App';

test('renders without crashing', () => {
  render(
    <BrowserRouter>
      <App />
    </BrowserRouter>
  );
  expect(screen.getByText(/Welcome to My E-Commerce App/i)).toBeInTheDocument(); // Replace with actual text in your app
});

test('renders routes correctly', () => {
  render(
    <BrowserRouter>
      <App />
    </BrowserRouter>
  );

  expect(screen.getByText(/Home/i)).toBeInTheDocument(); // Replace with navigation links or default component text
});
