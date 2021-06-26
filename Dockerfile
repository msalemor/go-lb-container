FROM golang:1.16 AS builder

# Set necessary environmet variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Move to working directory /build
WORKDIR /build

# Copy and download dependency using go mod
# COPY go.mod .
# COPY go.sum .
# RUN go mod download

# Copy the code into the container
COPY . .
RUN go mod download

# Build the application
RUN go build -o main .

# Move to /dist directory as the place for resulting binary folder
WORKDIR /dist

# Copy binary from build to main folder
RUN cp /build/main .

# Build a small image
FROM scratch

COPY --from=builder /dist/main /

ENV TARGET_PORT=8080
ENV CUSTOM_MESSAGE="This is a custom message"

EXPOSE 8080

USER nobody

# Command to run
ENTRYPOINT ["/main"]

# ROM golang:1.16 AS builder

# WORKDIR /myapp

# # # Enable Go's DNS resolver to read from /etc/hosts
# # RUN echo "hosts: files dns" > /etc/nsswitch.conf.min

# # # Create a minimal passwd so we can run as non-root in the container
# # RUN echo "nobody:x:65534:65534:Nobody:/:" > /etc/passwd.min

# # # Fetch latest CA certificates
# # RUN apt-get update && \
# #     apt-get install -y ca-certificates

# # Only download Go modules (improves build caching)
# COPY go.mod go.sum ./
# RUN go mod download

# # Copy our source code over and build the binary
# COPY . .
# #RUN CGO_ENABLED=0 \
# #    go build -ldflags '-s -w' -tags 'osusergo netgo' myapp
# #RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /app

# #COPY . .
# #RUN go get .
# RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# FROM scratch AS final

# # Copy over the binary artifact
# COPY --from=builder /app/containerinfo /

# ENV TARGET_PORT=8080
# ENV CUSTOM_MESSAGE="This is a custom message"
# EXPOSE 8080

# # Add any other assets you need, e.g.:
# # COPY --from=builder /myapp/static/ /static
# # COPY templates/ /templates

# # Copy configuration from builder
# # COPY --from=builder /etc/nsswitch.conf.min /etc/nsswitch.conf
# # COPY --from=builder /etc/passwd.min /etc/passwd
# # COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# # USER nobody

# ENTRYPOINT ["/containerinfo"]