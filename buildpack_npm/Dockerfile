FROM quay.io/actcat/buildpack_base:latest

MAINTAINER Vexus2 <hikaru.tooyama@gmail.com>

# Install node.js and npm
RUN apt-get update -y && apt-get install -y nodejs npm
RUN npm install n -g && n latest &&  ln -sf /usr/local/bin/node /usr/bin/node
RUN node -v

