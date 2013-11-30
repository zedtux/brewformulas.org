require 'coveralls/rake/task'
Coveralls::RakeTask.new
task :default => [:spec, :cucumber, 'coveralls:push']
