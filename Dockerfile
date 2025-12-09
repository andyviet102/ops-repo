# Stage 1: Build
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod ./
# COPY go.sum ./ 
# (Uncomment above if you have dependencies)

RUN go mod download

COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -o server main.go

# Stage 2: Run
FROM alpine:latest  

WORKDIR /root/

COPY --from=builder /app/server .

EXPOSE 8080

CMD ["./server"]
