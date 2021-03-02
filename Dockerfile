FROM alpine:3.13

ARG BUILD_DATE
ARG VCS_REF

ENV TZ=America/New_York

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/jcostom/oxidized-docker-alpine.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0"

RUN apk --no-cache add --virtual oxidized-runtime \
        ruby git libssh2 sqlite-libs libressl icu \
    && apk --no-cache add --virtual oxidized-build-deps \
        ruby-dev cmake make libssh2-dev g++ sqlite-dev libressl-dev icu-dev \
    && gem install \
        --no-document \
        json \
        aws-sdk \
        slack-api \
        oxidized \
        oxidized-script \
        oxidized-web \
    && apk --no-cache del oxidized-build-deps
RUN mkdir -p /root/.config /etc/oxidized /var/run/oxidized /var/lib/oxidized \
        && ln -sf /etc/oxidized /root/.config/oxidized
VOLUME ["/etc/oxidized", "/var/run/oxidized", "/var/lib/oxidized"]
EXPOSE 8888/tcp
ENTRYPOINT ["/usr/bin/oxidized"]
