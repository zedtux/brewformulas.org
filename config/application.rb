require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BrewformulasOrg
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.author = 'HAIN Guillaume <zedtux@zedroot.org>'
    config.title = 'Search and discover Homebrew formulae'
    config.description = 'Homebrew (The missing package manager for OS X) ' \
                         'formula list to search and discover new formulas'
    config.keywords = 'MAC, Apple, Homebrew, brew, mxcl, Formula, Formulas, ' \
                      'Formulae, search, description'

    config.homebrew = OpenStruct.new
    config.homebrew.git_repository = OpenStruct.new
    config.homebrew.git_repository.url = 'https://github.com/Homebrew/homebrew-core.git'
    config.homebrew.git_repository.name = 'homebrew'
    config.homebrew.git_repository.location = File.join(Rails.root, 'cache')

    config.opbeat.organization_id = ENV['OPBEAT_ORGANIZATION_ID']
    config.opbeat.app_id = ENV['OPBEAT_APP_ID']
    config.opbeat.secret_token = ENV['OPBEAT_SECRET_TOKEN']
    config.opbeat.logger = Rails.logger

    config.autoload_paths << Rails.root.join('app', 'sweepers')
    config.active_record.observers = :formulas_sweeper
  end
end
