# Demo Dockerfile for BoringCache Actions
# Supports multi-stage builds with builder and runtime targets

ARG NODE_ENV=development
ARG VERSION=dev

# Builder stage
FROM node:20-alpine AS builder
ARG NODE_ENV
ARG VERSION

WORKDIR /app

# Create a simple package.json for demo
RUN echo '{"name":"demo","version":"1.0.0"}' > package.json

# Simulate build step
RUN echo "Building with NODE_ENV=${NODE_ENV} VERSION=${VERSION}" > build-info.txt

# Runtime stage
FROM node:20-alpine AS runtime
ARG NODE_ENV
ARG VERSION

WORKDIR /app

COPY --from=builder /app/build-info.txt .
COPY --from=builder /app/package.json .

ENV NODE_ENV=${NODE_ENV}

CMD ["cat", "build-info.txt"]
