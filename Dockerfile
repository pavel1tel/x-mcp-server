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

# Copy package files (package-lock.json is in .gitignore, so we'll use npm install)
COPY package.json ./

# Install all dependencies (including dev dependencies for build)
RUN npm install && npm cache clean --force

# Copy source files
COPY tsconfig.json ./
COPY src ./src

# Build TypeScript
RUN npm run build

# Expose the port
EXPOSE ${PORT}

# Run the HTTP server (PORT env var triggers HTTP mode)
CMD ["node", "build/index.js"]

