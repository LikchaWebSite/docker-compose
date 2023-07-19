FROM        golang AS build
WORKDIR     /go/src/github.com/adnanh/webhook
ENV         WEBHOOK_VERSION 2.8.1
RUN         curl -L --silent -o webhook.tar.gz https://github.com/adnanh/webhook/archive/${WEBHOOK_VERSION}.tar.gz && \
            tar -xzf webhook.tar.gz --strip 1
RUN         go get -d -v
RUN         CGO_ENABLED=0 go build -ldflags="-s -w" -o /usr/local/bin/webhook

FROM        scratch
COPY        --from=build /usr/local/bin/webhook /usr/local/bin/webhook

WORKDIR     /etc/webhook

ENTRYPOINT  ["/usr/local/bin/webhook"]