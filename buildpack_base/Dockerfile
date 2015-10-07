FROM ubuntu:14.04

MAINTAINER Vexus2 <hikaru.tooyama@gmail.com>

RUN apt-get dist-upgrade -y

RUN apt-get update -y && apt-get install -y \
    autoconf \
    build-essential \
    imagemagick \
    libbz2-dev \
    libcurl4-openssl-dev \
    libevent-dev \
    libffi-dev \
    libglib2.0-dev \
    libjpeg-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libmysqlclient-dev \
    libncurses-dev \
    libpq-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    wget \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -y \
    git \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -y \
    curl \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -y curl procps && rm -rf /var/lib/apt/lists/*
