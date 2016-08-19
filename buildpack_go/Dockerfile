FROM quay.io/actcat/buildpack_base:latest

MAINTAINER pocke <p.ck.t22@gmail.com>

ENV GO_VERSION 1.7

# Install go from binary distributions. https://golang.org/dl/
RUN curl -sSL https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz \
  | tar -C /usr/local -xz

ENV GOROOT /usr/local/go
ENV GOPATH /root/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin
