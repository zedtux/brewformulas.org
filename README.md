<p align="center">
  <img src="https://raw.github.com/zedtux/gpair/master/media/developpeur_breton_logo.png" alt="Je suis un développeur Breton!"/>
</p>

# brewformulas.org

[![Build Status](https://travis-ci.org/zedtux/brewformulas.org.png?branch=master)](https://travis-ci.org/zedtux/brewformulas.org) [![Coverage Status](https://coveralls.io/repos/zedtux/brewformulas.org/badge.png)](https://coveralls.io/r/zedtux/brewformulas.org) [![Code Climate](https://codeclimate.com/github/zedtux/brewformulas.org.png)](https://codeclimate.com/github/zedtux/brewformulas.org) [![Dependency Status](https://gemnasium.com/zedtux/brewformulas.org.png)](https://gemnasium.com/zedtux/brewformulas.org) [![PullReview stats](https://www.pullreview.com/github/zedtux/brewformulas.org/badges/master.svg?)](https://www.pullreview.com/github/zedtux/brewformulas.org/reviews/master) [![Stack Share](http://img.shields.io/badge/tech-stack-0690fa.svg?style=flat)](http://stackshare.io/zedtux/brewformulas-org)

[Brewformulas.org](http://brewformulas.org) is a website to easily search and discover Homebrew formulas.

# About this repository

This repository hosts the source code of http://brewformulas.org/.
It is a Rails 4 and Ruby 2 application using Twitter bootstrap for the UI and sidekiq for the background jobs.

The aim of http://brewformulas.org/ is to provide a fast and simple web site to search for a [Homebrew](https://github.com/Homebrew/homebrew) formula.

The website is under heavy development so feel free to check regularly in order to discover new features.

# Documentation

In the case you would like to get access to the technical documentation,
[it's over here](http://rdoc.info/github/zedtux/brewformulas.org/master/frames).

# Build a new Docker container instance

When a new release is ready, here are the steps to follow to build and publish
a new container :

```
$ docker build -f Dockerfile.production -t `whoami`/brewformulas.org .
$ docker tag `whoami`/brewformulas.org quay.io/`whoami`/brewformulas.org
$ docker push quay.io/`whoami`/brewformulas.org
```
