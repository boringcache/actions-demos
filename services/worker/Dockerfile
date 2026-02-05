FROM node:20-alpine
WORKDIR /app
RUN echo '{"name":"worker"}' > package.json
CMD ["node", "-e", "console.log('Worker service')"]
