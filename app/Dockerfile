# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy all source files first
COPY . .

# Download dependencies (generates go.sum if missing)
RUN go mod tidy && go mod download

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /app/server .

# Production stage
FROM scratch

COPY --from=builder /app/server /server

EXPOSE 8080

USER 65534

ENTRYPOINT ["/server"]
