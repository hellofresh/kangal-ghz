FROM alpine:3.13 AS builder
RUN apk add --no-cache --upgrade \
  jq~=1.6 \
  curl~=7 \
&& curl -X GET -H "Accept:application/octet-stream" -fsSL "https://github.com/bojand/ghz/releases/latest/download/ghz-linux-x86_64.tar.gz" -o "ghz-linux-x86_64.tar.gz" \
&& tar -xzf "ghz-linux-x86_64.tar.gz" -C tmp

FROM ubuntu:20.04
WORKDIR /app
RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates
COPY --from=builder /tmp/ghz /bin/ghz
COPY entrypoint.sh .

ENTRYPOINT ["/app/entrypoint.sh"]
