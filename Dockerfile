# Brewformulas.org web application Docker image
#
# VERSION       1.0

# ~~~~ Image base ~~~~
FROM litaio/ruby:2.1.5
MAINTAINER zedtux, zedtux@zedroot.org


# ~~~~ OS Maintenance ~~~~
# Keep up-to-date the container OS
RUN apt-get update && apt-get install -y libpq-dev wget git


# ~~~~ Newrelic ~~~~
RUN echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list && \
  wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
  apt-get update && \
  apt-get install -y newrelic-sysmond


# ~~~~ Rails Preparation ~~~~
RUN mkdir /application/
# Rubygems
RUN gem install rubygems-update --no-ri --no-rdoc && update_rubygems
# Bundler
RUN gem install bundler --no-ri --no-rdoc
# Copy the Gemfile and Gemfile.lock into the image.
# Temporarily set the working directory to where they are.
WORKDIR /application/
ADD Gemfile /application/Gemfile
ADD Gemfile.lock /application/Gemfile.lock
RUN bundle --without development test cucumber

# ~~~~ Sources Preparation ~~~~
# Import the Brewformulas source code
ADD . /application/
RUN rm -rf /application/.git/

RUN bundle exec rake assets:precompile RAILS_ENV=production

ENTRYPOINT ["bundle exec"]
