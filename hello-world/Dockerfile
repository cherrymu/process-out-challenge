# Use the official Golang image for building the binary
FROM golang:1.22-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files and download dependencies
COPY go.mod ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the Go binary
RUN go build -o hello-world

# Use a minimal base image to run the application
FROM alpine:3.17

# Set the working directory inside the container
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/hello-world .

# Expose the port that the application will run on
EXPOSE 8080

# Run the Go application
CMD ["./hello-world"]
