# Brewformulas.org web application Docker image
#
# 1) Start a PostgreSQL
#   $ docker run -d --name=bfdb postgres:9
# 2) Start a Redis
#   $ docker run -d --name=bfred redis:2.8
# 3) Start the UI
#   $ docker run --rm --link bfdb:postgres --link bfred:redis -p 3000:3000 -e POSTGRESQL_USER=postgres zedtux/brewformulas
# 4) Run sidekiq
#   $ docker run --rm --link bfdb:postgres --link bfred:redis -e POSTGRESQL_USER=postgres zedtux/brewformulas sidekiq
#
# When first run use the following command to setup the postgres db:
#   docker run --rm --link bfdb:postgres --link bfred:redis -e POSTGRESQL_USER=postgres zedtux/brewformulas rake db:create db:migrate
# In the case you have a dump of the database to import (Don't execute the db:migrate):
#   $ cd /path/where/the/import/is/
#   $ docker run --rm -i --link brewformulasdb:postgres -v $PWD/:/tmp/ postgres:latest bash -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres -d <table_name> < /tmp/<dump_file_name>.sql
#
# VERSION       1.0

# ~~~~ Image base ~~~~
FROM ruby:2.3.0-slim
MAINTAINER zedtux, zedtux@zedroot.org

ENV RUNNING_IN_DOCKER true

# ~~~~ System Dependencies ~~~~
RUN apt-get install -y ca-certificates && \
  echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list && \
  curl https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
  apt-get update && \
  # libfreetype6 libfontconfig1 are used for Phantomjs
  apt-get install -y libpq-dev git make g++ gcc libfreetype6 libfontconfig1 \
  newrelic-sysmond && \
# ~~~~ Application ~~~~
  mkdir -p /brewformulas/application/ && \
  gem install rubygems-update --no-ri --no-rdoc && \
  update_rubygems && \
  gem install bundler --no-ri --no-rdoc

# ~~~~ Set up the environment ~~~~
ENV PHANTOMJS_VERSION 1.9.8

# ~~~~ Phantomjs ~~~~
RUN cd /tmp && \
    curl -L -O https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
    tar xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
    mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin && \
    rm -rf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64


# ~~~~ Rails Preparation ~~~~
# Rubygems
RUN gem install rubygems-update && update_rubygems
# Bundler
RUN gem install bundler

ENV APP_HOME /application
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

# --- Add this to your Dockerfile ---
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=8 \
  BUNDLE_PATH=/bundle

RUN bundle install --without production

ADD . $APP_HOME
