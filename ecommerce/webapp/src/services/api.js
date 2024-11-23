import axios from 'axios';

const getProducts = async () => {
  const response = await axios.get('http://localhost:5000/api');
  return response.data;
};

export default getProducts;

