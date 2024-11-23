# Use an official Node.js image to build the React app
FROM node:18 as build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY ./package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the code and build the React app
COPY . .

# Build the app for production
RUN npm run build

# Ensure permissions are correct
RUN chmod -R 755 /app

# Use an official Nginx image to serve the built React app
FROM nginx:alpine

# Copy the build output to Nginx's public directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 for serving the app
EXPOSE 80

# Command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
