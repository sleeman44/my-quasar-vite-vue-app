# Dockerfile

# Step 1: Use a Node.js base image for the build process
FROM node:lts-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install
RUN npm install -g @vue/cli
RUN npm install -g @quasar/cli

RUN quasar build

# Copy the rest of the application source code to the container
COPY . .

# Build the Quasar app for production
RUN npm run build

# Step 2: Use Nginx to serve the built Quasar app
FROM nginx:stable-alpine

# Copy the built files from the build stage to Nginx's default HTML directory
COPY --from=build /app/dist/spa /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
