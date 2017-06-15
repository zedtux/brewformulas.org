# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
begin
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'

  RSpec::Core::RakeTask.new

  task default: [:spec, :cucumber]
rescue LoadError => error
  unless Rails.env.production?
    puts 'WARNING: Could not load the RSpec and/or Cucumber Rake tasks' \
         "(#{error.inspect})"
  end
end

Rails.application.load_tasks
