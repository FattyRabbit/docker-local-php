FROM golang:1.16-alpine3.12 as builder
MAINTAINER kugyon.i <fatty.rabbit.dev@gmail.com>

RUN set -x \
  && buildDeps='git musl-dev gcc' \
  && apk add --update $buildDeps \
  && GOPATH=/tmp/gocode go get github.com/mailhog/MailHog

FROM alpine:3.12
WORKDIR /bin
COPY --from=builder tmp/gocode/bin/MailHog /bin/MailHog
EXPOSE 1025 8025
ENTRYPOINT ["MailHog"]
