ifdef(`SERVICE',, `define(`SERVICE', `docker-rd_web')')dnl
FROM alpine:3.2
MAINTAINER Daniel Enman <enmand@gmail.com>

RUN apk add --update go make git

COPY . /go/src/github.com/enmand/docker-rd
ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
WORKDIR /go/src/github.com/enmand/docker-rd
RUN make bin/SERVICE && \
    mv bin/SERVICE /usr/local/bin/SERVICE

RUN apk del go make
