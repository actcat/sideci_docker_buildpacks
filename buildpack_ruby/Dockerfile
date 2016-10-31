FROM quay.io/actcat/buildpack_base:latest

MAINTAINER Vexus2 <hikaru.tooyama@gmail.com>

# Ruby is installed in buildpack_base

# skip installing gem documentation
RUN echo 'gem: --no3rdoc --no-ri' >> "$HOME/.gemrc"

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH
RUN gem install bundler \
  && bundle config --global path "$GEM_HOME" \
  && bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME
