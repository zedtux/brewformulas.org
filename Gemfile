source 'https://rubygems.org'

gem 'rails'
gem 'responders'
gem 'uglifier'
gem 'jquery-rails'
gem 'less-rails'
gem 'therubyracer', platforms: :ruby
gem 'bootstrap-on-rails'
gem 'turbolinks'
gem 'pg'
gem 'puma'
gem 'slim-rails'
gem 'git'
gem 'appconfig', require: 'app_config'
gem 'sidekiq'
# https://github.com/mperham/sidekiq/blob/master/lib/sidekiq/redis_connection.rb#L44
gem 'redis-namespace'
gem 'sidetiq' # Recurring jobs
gem 'sinatra', '>= 1.3.0', require: nil
gem 'newrelic_rpm'
gem 'nokogiri'
# open-uri library patched to follow http to https redirects
gem 'open_uri_redirections'
# Implemented the missing uniq? method on Ruby Arrays
gem 'array_is_uniq', require: 'array'
gem 'pluralize_no_count_if_one'
gem 'quiet_assets'
# Markdown required gem
gem 'redcarpet'
# Pagination
gem 'kaminari'

group :assets do
  gem 'coffee-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri_19, :mri_20, :rbx]
  # Command-line wrapper for git that makes you better at GitHub
  gem 'hub', require: nil
  # Generates Rails application layout files for use with various front-end
  # frameworks.
  gem 'rails_layout'
  # YARD is a documentation generation tool for the Ruby programming language.
  gem 'yard'
  # A code metric tool for rails codes, written in Ruby.
  gem 'rails_best_practices'
  # Automatic Ruby code style checking tool. Aims to enforce the
  # community-driven Ruby Style Guide.
  gem 'rubocop', require: false
end

group :test, :cucumber do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'cucumber-timecop', '0.0.3', require: false
  gem 'rake'
  gem 'webmock'
  gem 'coveralls', require: false
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'selenium-webdriver'
end
