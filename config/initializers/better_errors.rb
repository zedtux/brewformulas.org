# Better errors
#
# https://github.com/charliesome/better_errors
#
# This file allow any IP adresses to access better errors excepted in
# production where better errors should be completely removed.
begin
  require 'better_errors'
  BetterErrors::Middleware.allow_ip! '0.0.0.0/0'
  BetterErrors.editor = 'atm://open?url=file://%{file}&line=%{line}'
rescue LoadError
  Rails.logger.warn 'WARNING: Better errors not loaded'
end
