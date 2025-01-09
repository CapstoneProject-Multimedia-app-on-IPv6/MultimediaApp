# Base image
FROM node:20-alpine3.20

# Set working directory to the webphim folder
WORKDIR /app

# Copy dependency files
COPY Server/package*.json ./
RUN npm ci
COPY Server .

EXPOSE 8089

CMD ["npm", "start"]
