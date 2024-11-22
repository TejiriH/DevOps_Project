import React, { useState } from 'react';

const OrderPlacement = () => {
  const [productId, setProductId] = useState('');
  const [quantity, setQuantity] = useState(1);
  const [isOrderPlaced, setIsOrderPlaced] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();
    // Simulate order placement
    setIsOrderPlaced(true);
  };

  return (
    <div className="order-placement">
      <h2>Place Your Order</h2>

      {isOrderPlaced ? (
        <div className="order-confirmation">
          <h3>Thank you for your order!</h3>
        </div>
      ) : (
        <form onSubmit={handleSubmit}>
          <div>
            <label>Product ID:</label>
            <input
              type="text"
              value={productId}
              onChange={(e) => setProductId(e.target.value)}
              required
            />
          </div>

          <div>
            <label>Quantity:</label>
            <input
              type="number"
              value={quantity}
              onChange={(e) => setQuantity(e.target.value)}
              min="1"
              required
            />
          </div>

          <button type="submit">Place Order</button>
        </form>
      )}
    </div>
  );
};

export default OrderPlacement;
