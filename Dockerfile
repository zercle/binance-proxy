# syntax=docker/dockerfile:1
# Builder from adrianceding/binance-proxy
FROM golang AS builder
ARG LATEST_TAG=v1.5.1
ENV BUILD_TAG $LATEST_TAG
WORKDIR /src/app
RUN git clone --depth 1 --branch ${BUILD_TAG} https://github.com/adrianceding/binance-proxy.git && cd binance-proxy/src/binance-proxy && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /src/app/dist/binance-proxy .

# Container from builder
FROM debian:stable-slim
LABEL maintainer="Kawin Viriyaprasopsook <kawin.vir@zercle.tech>"

ARG	timezone=Asia/Bangkok

ENV	LANG C.UTF-8
ENV	LC_ALL C.UTF-8
ENV	TZ $timezone

# Update OS
RUN	apt update && apt -y full-upgrade \
  && apt -y install locales tzdata net-tools bash-completion ca-certificates

# Change locale
RUN echo $timezone > /etc/timezone \
  && cp /usr/share/zoneinfo/$timezone /etc/localtime

# Create app dir
RUN mkdir -p /app
WORKDIR /app
COPY --from=builder /src/app/dist/binance-proxy /app/
RUN chmod +x /app/binance-proxy && ln -sf /app/binance-proxy /usr/local/bin/binance-proxy

EXPOSE 8090 8091

# startup script
ENTRYPOINT ["binance-proxy"]
# fallback
CMD ["binance-proxy"]
