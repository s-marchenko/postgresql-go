FROM golang:1.17.2-alpine3.14 as builder

RUN apk update && apk add --no-cache git

# Set current working directory
WORKDIR /app

COPY . .
RUN go mod download
RUN go get -u github.com/gobuffalo/packr/packr

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 packr build -o ./bin/website_linux_amd64 .

# Start a new stage from scratch
FROM alpine:3.14

COPY --from=builder /app/bin/website_linux_amd64 .

# Run executable
CMD ["./website_linux_amd64"]