source 'https://rubygems.org'

gem 'rails', '4.0.1'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'less-rails'
gem 'therubyracer', :platforms => :ruby
gem 'bootstrap-on-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'pg'
gem 'puma'
gem 'slim-rails'
gem 'git'
gem 'appconfig', :require => 'app_config'
gem 'sidekiq'
gem 'sidetiq', '~> 0.4.3' # Recurring jobs
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'newrelic_rpm'
gem 'nokogiri'
gem 'open_uri_redirections' # open-uri library patched to follow http to https redirects
gem 'array_is_uniq', :require => 'array' # Implemented the missing unqi? method on Ruby Arrays
gem 'pluralize_no_count_if_one'

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
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'shoulda-matchers', :git => "https://github.com/thoughtbot/shoulda-matchers.git"
  gem 'cucumber-timecop', :require => false
  gem 'rake'
  gem 'webmock'
  gem 'coveralls', require: false
end
