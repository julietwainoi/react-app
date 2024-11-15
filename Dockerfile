# Use an official Node.js runtime as a parent image
FROM node:20 as build

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json first to leverage Docker cache
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the app for production
RUN npm run build

# Serve the app using a static server (Nginx)
FROM nginx:alpine

# Copy the build output from the first stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose the port Nginx will run on
EXPOSE 80

# Run Nginx to serve the React app
CMD ["nginx", "-g", "daemon off;"]
