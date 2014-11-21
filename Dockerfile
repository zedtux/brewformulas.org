# Brewformulas.org web application Docker image
#
# 1) Start a PostgreSQL
#   docker run -d --name=bfdb postgres:9
# 2) Start a Redis
#   docker run -d --name=bfred redis:2.8
# 3) Start the UI
#   docker run --rm --link bfdb:postgres --link bfred:redis -p 3000:3000 -e POSTGRESQL_USER=postgres zedtux/brewformulas
# 4) Run sidekiq
#   docker run --rm --link bfdb:postgres --link bfred:redis -e POSTGRESQL_USER=postgres zedtux/brewformulas sidekiq
#
# When first run use the following command to setup the postgres db:
#   docker run --rm --link bfdb:postgres --link bfred:redis -e POSTGRESQL_USER=postgres zedtux/brewformulas rake db:create db:migrate
#
# VERSION       1.0

# ~~~~ Image base ~~~~
FROM litaio/ruby:2.1.5
MAINTAINER zedtux, zedtux@zedroot.org

ENV RUNNING_IN_DOCKER true

# ~~~~ System Dependencies ~~~~
RUN apt-get install -y ca-certificates && \
  echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list && \
  curl https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
  apt-get update && \
  apt-get install -y libpq-dev \
  git \
  newrelic-sysmond && \
# ~~~~ Application ~~~~
  mkdir /application/ && \
  gem install rubygems-update --no-ri --no-rdoc && \
  update_rubygems && \
  gem install bundler --no-ri --no-rdoc

# Copy the Gemfile and Gemfile.lock into the image.
# Temporarily set the working directory to where they are.
WORKDIR /application/
ADD Gemfile /application/Gemfile
ADD Gemfile.lock /application/Gemfile.lock
ADD vendor/cache/ /application/vendor/cache/
RUN bundle install --local --deployment --without development test cucumber

# ~~~~ Sources Preparation ~~~~
# Import the Brewformulas source code
ADD . /application/
RUN rm -rf /application/.git/

RUN bundle exec rake assets:precompile RAILS_ENV=production

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]
CMD ["bin/rails server"]
