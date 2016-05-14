FROM alpine:edge
MAINTAINER Tobias Gesellchen <tobias@gesellix.de> (@gesellix)

RUN apk add -U openssl

ENV DOMAIN example.com
ENV PORT 5000

CMD ["/entrypoint.sh"]

COPY entrypoint.sh /entrypoint.sh
COPY restart-docker.sh /restart-docker.sh
