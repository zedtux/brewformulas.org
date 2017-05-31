# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new

Rails.application.load_tasks

task default: [:spec, :cucumber]
