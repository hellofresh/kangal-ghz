FROM golang:1.24 AS builder
WORKDIR /app
COPY ./ ./

RUN CGO_ENABLED=0 go build greeter_server/main.go

FROM scratch
COPY --from=builder /app/main /main
ENTRYPOINT ["/main"]
