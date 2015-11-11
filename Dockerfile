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
FROM ruby:2.2.3-slim
MAINTAINER zedtux, zedtux@zedroot.org

ENV RUNNING_IN_DOCKER true

# ~~~~ System Dependencies ~~~~
RUN apt-get install -y ca-certificates && \
  echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list && \
  curl https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
  apt-get update && \
  apt-get install -y libpq-dev git make g++ gcc \
  newrelic-sysmond && \
# ~~~~ Application ~~~~
  mkdir -p /brewformulas/application/ && \
  gem install rubygems-update --no-ri --no-rdoc && \
  update_rubygems && \
  gem install bundler --no-ri --no-rdoc

# ~~~~ Sources Preparation ~~~~
# Prepare gems
WORKDIR /brewformulas/application/
ADD . /brewformulas/application/
RUN bundle install --without production --jobs 8

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]
