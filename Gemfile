source 'https://rubygems.org'

gem 'rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'less-rails'
gem 'therubyracer', :platforms => :ruby
gem 'bootstrap-on-rails'
gem 'turbolinks'
gem 'pg'
gem 'puma'
gem 'slim-rails'
gem 'git'
gem 'appconfig', :require => 'app_config'
gem 'sidekiq', '~> 2.17.7'
gem 'sidetiq' # Recurring jobs
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'newrelic_rpm'
gem 'nokogiri'
gem 'open_uri_redirections' # open-uri library patched to follow http to https redirects
gem 'array_is_uniq', :require => 'array' # Implemented the missing unqi? method on Ruby Arrays
gem 'pluralize_no_count_if_one'

group :assets do
  gem 'coffee-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'hub', :require => nil
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'yard'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'rails_best_practices'
  gem 'rubocop'
  gem 'capistrano3-puma'
end

group :test, :cucumber do
  gem 'capybara'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'shoulda-matchers', :git => "https://github.com/thoughtbot/shoulda-matchers.git"
  gem 'cucumber-timecop', :require => false
  gem 'rake'
  gem 'webmock'
  gem 'coveralls', require: false
end
