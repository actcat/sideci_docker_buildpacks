FROM quay.io/actcat/buildpack_base:latest

ENV GO_VERSION 1.7

RUN curl -sSL https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz \
  | tar -C /usr/local -xz

ENV GOROOT /usr/local/go
ENV GOPATH /root/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -
RUN apt-get update -y && apt-get install -y nodejs

RUN apt-get update -y && apt-get install -y php5 php-pear

# Install pyenv
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# Install python 2 and 3
RUN pyenv install 2.7.10 \
  && pyenv install 3.5.0 \
  && pyenv rehash        \
  && pyenv global 3.5.0

ENV RUBY_MAJOR 2.3
ENV RUBY_VERSION 2.3.0

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN apt-get update -y \
  && apt-get install -y bison ruby \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/src/ruby \
  && curl -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
    | tar -xjC /usr/src/ruby --strip-components=1 \
  && cd /usr/src/ruby \
  && autoconf \
  && ./configure --disable-install-doc \
  && make -j"$(nproc)" \
  && apt-get purge -y --auto-remove bison ruby \
  && make install \
  && rm -r /usr/src/ruby

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

# ------------------------------

ENV GO_LINT_TOOL_VERSION "e63253f61b185555cb502b7f7deb29c99faadc79"

RUN go get -d github.com/alecthomas/gometalinter \
  && cd $GOPATH/src/github.com/alecthomas/gometalinter/ \
  && git checkout $GO_LINT_TOOL_VERSION \
  && go install \
  && gometalinter --install --update \
  && echo "gometalinter version: ${GO_LINT_TOOL_VERSION}"

ENV COFFEEE_LINT_TOOL_VERSION "1.15.0"

# Install coffeelint from https://www.npmjs.com/package/coffeelint
RUN npm install -g coffeelint@${COFFEEE_LINT_TOOL_VERSION} \
 && coffeelint --version

ENV LINT_TOOL_VERSION "3.2.2"

# Install eslint from https://www.npmjs.com/package/eslint
RUN npm install -g eslint@${LINT_TOOL_VERSION} \
   && eslint --version

# Add all available eslint-plugins
ADD enable_eslint_plugins.txt /root/enable_eslint_plugins.txt
RUN xargs -L 1 npm install -g < /root/enable_eslint_plugins.txt 2> /dev/null || echo 'Install available eslint plugins'
RUN npm list -g | grep eslint

# Add .eslintrc sample file
ADD eslintrc_sample /root/eslintrc_sample

# Download and place SideCI Recommended Configurations
RUN wget https://raw.githubusercontent.com/actcat/sideci_config/master/javascript/jshint/sideci_jshintignore -P ~/
RUN wget https://raw.githubusercontent.com/actcat/sideci_config/master/javascript/jshint/sideci_jshintrc -P ~/


ENV LINT_TOOL_VERSION "2.9.1"

# Install jshint from https://www.npmjs.com/package/jshint
RUN npm install -g jshint@${LINT_TOOL_VERSION} \
  && jshint --version

ENV LINT_TOOL_VERSION "3.2.1"

# Install tslint from https://www.npmjs.com/package/tslint
RUN npm install -g tslint@${LINT_TOOL_VERSION} \
  && tslint --version

RUN apt-get update -y && apt-get install -y unzip

ENV LINT_TOOL_VERSION "2.6.0"

# Install PHP_CodeSniffer from http://pear.php.net/package/PHP_CodeSniffer/
RUN pear install PHP_CodeSniffer-${LINT_TOOL_VERSION}

# set codesniffer of cakephp
RUN wget https://github.com/cakephp/cakephp-codesniffer/archive/master.zip
RUN unzip master.zip
RUN mv cakephp-codesniffer-master/CakePHP /usr/share/php/PHP/CodeSniffer/Standards/
RUN rm -rf master.zip cakephp-codesniffer-master/

# set codesniffer of codeigniter
RUN wget https://github.com/thomas-ernest/CodeIgniter-for-PHP_CodeSniffer/archive/master.zip
RUN unzip master.zip
RUN mv CodeIgniter-for-PHP_CodeSniffer-master/src /usr/share/php/PHP/CodeSniffer/Standards/CodeIgniter
RUN rm -rf master.zip CodeIgniter-for-PHP_CodeSniffer-master/

# Install Symfony2 codingstandard for phpcs
RUN wget https://github.com/escapestudios/Symfony2-coding-standard/archive/master.zip
RUN unzip master.zip
RUN mv Symfony2-coding-standard-master/Symfony2 /usr/share/php/PHP/CodeSniffer/Standards
RUN rm master.zip

# Install fuelphp codingstandard for phpcs
RUN wget https://github.com/eviweb/fuelphp-phpcs/archive/master.zip
RUN unzip master.zip
RUN mv fuelphp-phpcs-master/Standards/FuelPHP /usr/share/php/PHP/CodeSniffer/Standards/
RUN rm -rf master.zip fuelphp-phpcs-master/

# Install WordPress Coding Standards for phpcs
RUN wget https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards/archive/master.zip
RUN unzip master.zip
RUN mv WordPress-Coding-Standards-master /usr/share/php/PHP/CodeSniffer/Standards/wpcs
RUN rm master.zip

RUN wget http://get.sensiolabs.org/php-cs-fixer.phar -O php-cs-fixer
RUN chmod a+x php-cs-fixer
RUN mv php-cs-fixer /usr/local/bin/php-cs-fixer

FROM quay.io/actcat/buildpack_php:latest

# install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Print composer version information
RUN composer -V

# Install composer_outdated command
ADD composer_outdated /usr/local/composer_outdated
RUN chmod +x /usr/local/composer_outdated/composer_outdated.php
RUN ln -s /usr/local/composer_outdated/composer_outdated.php /usr/local/bin/composer_outdated

ENV LINT_TOOL_VERSION "2.4.3"

# install phpmd latest via phpmd site. PHP Mess Dedector
RUN wget -c http://static.phpmd.org/php/${LINT_TOOL_VERSION}/phpmd.phar
RUN mv phpmd.phar /usr/bin/phpmd
RUN chmod +x /usr/bin/phpmd
RUN phpmd --version

ENV LINT_TOOL_VERSION "2.5.1"

# Install flake8 for python 2 and 3
# And use python3 as default
RUN  PYTHON2VERSION=$(pyenv versions | sed -E 's/^\*/ /' | grep -E '^\s+2\.' | tail -1 | sed -E 's/^\s+([0-9.]+).*$/\1/') \
  && PYTHON3VERSION=$(pyenv versions | sed -E 's/^\*/ /' | grep -E '^\s+3\.' | tail -1 | sed -E 's/^\s+([0-9.]+).*$/\1/') \
  && pip install flake8==${LINT_TOOL_VERSION}\
  && pyenv rehash \
  && flake8 --version \
  && pyenv global $PYTHON2VERSION \
  && pip install flake8==${LINT_TOOL_VERSION} \
  && pyenv rehash \
  && flake8 --version \
  && pyenv global $PYTHON3VERSION

ENV LINT_TOOL_VERSION "3.3.5"

# Brakeman is depend on slim for slim user. https://rubygems.org/gems/slim/versions
# Install brakeman from https://rubygems.org/gems/brakeman/versions
RUN gem install brakeman -v ${LINT_TOOL_VERSION} \
  && gem install slim \
  && brakeman --version

# install bundler_outdated script
ADD bundler_outdated /usr/local/bundler_outdated
RUN chmod +x /usr/local/bundler_outdated/gem_analysis.rb
RUN ln -s /usr/local/bundler_outdated/gem_analysis.rb /usr/local/bin/bundler_outdated
RUN cd /usr/local/bundler_outdated; bundle install \
  && bundler_outdated --version

# Install astrolabe for rubocop 0.36 because haml-lint dependencies this gem missing
RUN gem install astrolabe

ENV LINT_TOOL_VERSION "0.17.1"

# Install haml lint from https://rubygems.org/gems/haml_lint
# rubocop-rspecがないと require: rubocop-rspec が書かれている環境でhaml_lintが落ちる
RUN gem install haml_lint -v ${LINT_TOOL_VERSION} \
  && gem install rubocop-rspec \
  && haml-lint --version

# Download and place SideCI Recommended Configurations
RUN wget https://raw.githubusercontent.com/actcat/sideci_config/master/ruby/rails_best_practices/sideci_rails_best_practices.yml -P ~/

ENV LINT_TOOL_VERSION "1.17.0"

# Add rails_best_practice(if you want to version, please set new version and rebuild this docker image.
RUN gem install rails_best_practices -v ${LINT_TOOL_VERSION} \
  && rails_best_practices --version \
  && gem list | grep code_analyzer


# Download and place SideCI Recommended Configurations
RUN wget https://raw.githubusercontent.com/actcat/sideci_config/master/ruby/reek/sideci_config.reek -O ~/sideci_config_reek
# Download and place Kanban Configurations
RUN wget https://raw.githubusercontent.com/actcat/sideci_config/master/ruby/reek/kanban_config.reek -O ~/kanban_config_reek

ENV LINT_TOOL_VERSION "4.4.0"

# Install reek from https://rubygems.org/gems/reek/versions/
RUN gem install reek -v ${LINT_TOOL_VERSION} \
  && reek --version

# Download and place SideCI Recommended Configurations
RUN wget -O ~/sideci_rubocop.yml https://raw.githubusercontent.com/actcat/sideci_config/master/ruby/rubocop/sideci_rubocop.yml?201604071905

# Install from
# - https://rubygems.org/gems/rubocop-rspec
# - https://rubygems.org/gems/rubocop-definition_validator
RUN gem install rubocop-rspec \
  && gem install rubocop-definition_validator -v 0.1.4

ENV LINT_TOOL_VERSION "0.42.0"

# 直近15versionsのRubocopをインストール
RUN curl https://rubygems.org/gems/rubocop/versions.atom  2>/dev/null | grep "<title>" | ruby -ple '$_ = $_[/rubocop \(([0-9.]+)\)/, 1];  next if !$_ || Gem::Version.new(ENV["LINT_TOOL_VERSION"]) < Gem::Version.new($_)' | head -15 | xargs -Iversion gem install rubocop -v version

ENV LINT_TOOL_VERSION "0.48.0"

# Install scss-lint from https://rubygems.org/gems/scss_lint
RUN gem install scss_lint -v ${LINT_TOOL_VERSION} \
  && scss-lint --version