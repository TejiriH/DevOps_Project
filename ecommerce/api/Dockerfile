# Use Node.js image for the backend
FROM node:18 AS backend

# Set the working directory
WORKDIR /app

# Copy the backend's package.json and package-lock.json
COPY ./api/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the backend code
COPY ./api ./

# Expose the backend port (e.g., 3000)
EXPOSE 3000

# Run the backend application (adjust to your start script)
CMD ["npm", "start"]

