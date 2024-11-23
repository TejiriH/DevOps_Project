# Use the official Node.js image as a base image
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first for efficient caching
COPY ./package*.json ./

# Install dependencies
RUN npm install

# Ensure files have the right permissions
RUN chmod -R 755 /app

# Copy the rest of the application
COPY . ./

# Run the build script
RUN npm run build

# Use Nginx to serve the built app
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html

# Expose the Nginx port
EXPOSE 80

