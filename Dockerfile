# Use an official Node runtime as a parent image
FROM node:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Install Mongo Express global admin
RUN npm install -g mongo-express

# Copy the custom configuration file
COPY mongo-express-config.js /node_modules/mongo-express/config.js

# Make port 8081 available to the world outside this container
EXPOSE 8081

# Define environment variable
ENV ME_CONFIG_MONGODB_ADMINUSERNAME=admin
ENV ME_CONFIG_MONGODB_ADMINPASSWORD=pass

# Run mongo-express
CMD ["mongo-express", "--admin"]
