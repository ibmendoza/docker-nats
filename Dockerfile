FROM alpine:3.4

ENV NATS_VERSION=0.9.4 \
    NATS_CLUSTER_USER=ruser \
    NATS_CLUSTER_PASSWORD=T0pS3cr3t \
    NATS_CLUSTER_TIMEOUT=2

# Install gnatsd
RUN apk add --update --no-cache ca-certificates \
 && update-ca-certificates \
 && apk add --no-cache openssl \
 && wget https://github.com/nats-io/gnatsd/releases/download/v${NATS_VERSION}/gnatsd-v${NATS_VERSION}-linux-386.zip \
 && unzip gnatsd-v${NATS_VERSION}-linux-386.zip \
 && mv gnatsd-v${NATS_VERSION}-linux-386/gnatsd /usr/bin/gnatsd \
 && rm gnatsd-v${NATS_VERSION}-linux-386.zip \
 && rm -r gnatsd-v${NATS_VERSION}-linux-386 \
 && apk del ca-certificates openssl

COPY entrypoint.sh /entrypoint.sh
COPY gnatsd.conf /etc/gnatsd.conf

RUN chmod 600 /etc/gnatsd.conf \
 && chmod 500 /entrypoint.sh

# Expose client, management, and cluster ports 
EXPOSE 4222 8222 6222 

ENTRYPOINT ["/entrypoint.sh"]
CMD ["gnatsd", "-c", "/etc/gnatsd.conf"]
