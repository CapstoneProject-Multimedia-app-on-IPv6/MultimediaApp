FROM node:20-alpine3.20

WORKDIR /app

# Copy dependency files
COPY Server/package*.json ./
RUN npm ci
COPY Server .

CMD ["npm", "start"]
