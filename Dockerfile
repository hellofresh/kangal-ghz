FROM alpine:latest AS builder
RUN apk add --no-cache --upgrade jq curl \
&& curl -X GET -H "Accept:application/octet-stream" -fsSL "https://github.com/bojand/ghz/releases/latest/download/ghz-linux-x86_64.tar.gz" -o "ghz-linux-x86_64.tar.gz" \
&& tar -xzf "ghz-linux-x86_64.tar.gz" -C tmp

FROM ubuntu:latest
COPY --from=builder /tmp/ghz /bin/ghz

ENTRYPOINT ["/bin/ghz"]
