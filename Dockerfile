FROM node:20-alpine

WORKDIR /app

# Build arguments (optional, for build-time configuration)
ARG TWITTER_API_KEY
ARG TWITTER_API_SECRET
ARG TWITTER_ACCESS_TOKEN
ARG TWITTER_ACCESS_SECRET
ARG PORT=8080

# Environment variables (runtime)
ENV TWITTER_API_KEY=${TWITTER_API_KEY}
ENV TWITTER_API_SECRET=${TWITTER_API_SECRET}
ENV TWITTER_ACCESS_TOKEN=${TWITTER_ACCESS_TOKEN}
ENV TWITTER_ACCESS_SECRET=${TWITTER_ACCESS_SECRET}
ENV PORT=${PORT}

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm ci && npm cache clean --force

# Copy source files
COPY tsconfig.json ./
COPY src ./src

# Install dev dependencies for build and build TypeScript
RUN npm ci && npm run build && rm -rf node_modules && npm ci

# Expose the port
EXPOSE ${PORT}

# Run the HTTP server (PORT env var triggers HTTP mode)
CMD ["node", "build/index.js"]

