FROM alpine:edge
MAINTAINER Tobias Gesellchen <tobias@gesellix.de> (@gesellix)

ENV DOMAIN example.com
ENV PORT 5000

CMD ["/entrypoint.sh"]

COPY entrypoint.sh /entrypoint.sh
COPY restart-docker.sh /restart-docker.sh

# docker run --rm -it -v `pwd`/certs:/certs -v /etc:/host-etc -e DOMAIN=example.com -e PORT=5000 gesellix/inject-docker-certs
