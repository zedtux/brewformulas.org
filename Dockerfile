# ~~~~ Image base ~~~~
FROM ruby:2.4.1-slim
MAINTAINER zedtux, zedtux@zedroot.org

ENV DEBIAN_FRONTEND noninteractive

# ~~~~ System locales ~~~~
RUN apt-get update && apt-get install -y locales && \
  dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8 && \
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV APP_HOME /application

# ~~~~ User and folders ~~~~
RUN useradd -ms /bin/bash brewformulas && \
  mkdir /bundle $APP_HOME && \
  chown -R brewformulas:brewformulas $APP_HOME && \
  chown -R brewformulas:users /usr/local/

# ~~~~ Application dependencies ~~~~
RUN apt-get install -y libpq-dev \
  build-essential \
  nodejs \
  git

# ~~~~ Bundler ~~~~
RUN gem install bundler

WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/

# ~~~~ Install Rails application gems ~~~~
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=8 \
  BUNDLE_PATH=/bundle

RUN gem install rubygems-update --no-ri --no-rdoc --version 2.7.0 && \
    update_rubygems && \
    bundle install --without production

# ~~~~ Import application ~~~~
COPY . $APP_HOME

RUN bundle exec rake assets:precompile RAILS_ENV=production

RUN chown -R brewformulas:brewformulas $APP_HOME && \
  chown -R brewformulas:users /bundle && \
  chown -R brewformulas:users /usr/local/bundle

USER brewformulas
