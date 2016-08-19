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
    python-software-properties \
    software-properties-common \
  && rm -rf /var/lib/apt/lists/*

# Install git from launchpad maintain repo
RUN add-apt-repository ppa:git-core/ppa -y && apt-get update -y && apt-get install -y \
    git \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -y \
    curl \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -y curl procps && rm -rf /var/lib/apt/lists/*

# Add locales
RUN locale-gen $(grep '\.UTF-8' /usr/share/i18n/SUPPORTED | awk '{ print $1 }')

# Set default locale
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-get update -y && apt-get install -y language-pack-ja
RUN update-locale en_US.UTF-8

RUN mkdir /root/work
WORKDIR /root/work

# Install hub
RUN wget https://github.com/github/hub/releases/download/v2.2.3/hub-linux-amd64-2.2.3.tgz
RUN tar -xf hub-linux-amd64-2.2.3.tgz
ENV PATH $PATH:/root/work/hub-linux-amd64-2.2.3/bin
RUN echo 'alias git=hub' >> ~/.bashrc
RUN mkdir /root/.config
ADD hub /root/.config/hub

# Set Git config
RUN git config --global diff.compactionHeuristic true
