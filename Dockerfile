FROM node:17-alpine as builder
# Set the working directory to /app inside the container
WORKDIR /app
# Copy app files
COPY package.json .
COPY package-lock.json .
RUN npm ci
COPY . .
# Build the app
RUN npm run build

# Bundle static assets with nginx
FROM nginx:1.19.0
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/build .
ENTRYPOINT [ "nginx", "-g", "daemon off;"]