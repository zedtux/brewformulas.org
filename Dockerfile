# Brewformulas.org web application Docker image
#
# VERSION       1.0

# ~~~~ Image base ~~~~
FROM litaio/ruby
MAINTAINER zedtux, zedtux@zedroot.org


# ~~~~ OS Maintenance ~~~~
# Keep up-to-date the container OS
RUN apt-get update && apt-get upgrade -y
# Install required header files for PostgreSQL in order to install pg gem
RUN apt-get install -y libpq-dev wget git


# ~~~~ Newrelic ~~~~
RUN echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list
RUN wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -
RUN apt-get update
RUN apt-get install newrelic-sysmond


# ~~~~ Rails Preparation ~~~~
RUN mkdir /application/
# Rubygems
RUN gem install rubygems-update --no-ri --no-rdoc
RUN update_rubygems
# Bundler
RUN gem install bundler --no-ri --no-rdoc
# Copy the Gemfile and Gemfile.lock into the image.
# Temporarily set the working directory to where they are.
WORKDIR /application/
ADD Gemfile /application/Gemfile
ADD Gemfile.lock /application/Gemfile.lock
RUN bundle --deployment --without development test cucumber

# ~~~~ Sources Preparation ~~~~
# Import the Brewformulas source code
ADD . /application/
RUN rm -rf /application/.git/

RUN bundle exec rake assets:precompile RAILS_ENV=production

# Run the Rails server
CMD bundle exec rails server
