# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files trước để tận dụng Docker cache
COPY package*.json ./

# FIX: Dùng npm ci thay vì npm install để cài chính xác các version trong lockfile
# Lệnh này giúp build nhanh hơn và tránh xung đột version
RUN npm ci

COPY . .

# Build project
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine

# Copy kết quả build từ stage builder sang thư mục html của nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# (Optional) Nếu ông có file cấu hình nginx riêng thì bỏ comment dòng dưới
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
