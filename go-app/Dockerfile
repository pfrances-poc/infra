FROM golang:1.24-bookworm AS builder
WORKDIR /app
COPY *.go go.mod ./
RUN go build -o server .

FROM debian:bookworm
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]