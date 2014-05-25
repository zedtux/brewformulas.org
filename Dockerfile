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


# ~~~~ User Home Maintenance ~~~~
# Clone the Git repository with the latest version from master branch
RUN mkdir -p /application/
WORKDIR /application/
# Import the Brewformulas source code
RUN git clone https://github.com/zedtux/brewformulas.org /application/


# ~~~~ Rails Preparation ~~~~
# Bundler
RUN gem install bundler


# ~~~~ Brewformulas.org ~~~~
# Switch the working directory
RUN bundle --deployment --without development test cucumber
