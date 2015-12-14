FROM alpine:3.2
MAINTAINER Daniel Enman <enmand@gmail.com>

RUN apk add --update go make
COPY . /go/src/githib.com/enmand/example-empire
ENV GOPATH /go
WORKDIR /go/src/githib.com/enmand/example-empire
RUN make && \
    mv bin/* /usr/local/bin
