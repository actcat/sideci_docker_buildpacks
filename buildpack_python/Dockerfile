FROM quay.io/actcat/buildpack_base:latest

MAINTAINER pocke <p.ck.t22@gmail.com>

# Install node.js and npm
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN pyenv install 2.7.10 \
  && pyenv install 3.5.0 \
  && pyenv rehash        \
  && pyenv global 3.5.0

RUN apt-get update -y
