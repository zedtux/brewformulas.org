begin
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task :default => [:spec, :cucumber, 'coveralls:push']
rescue LoadError
  # When loading this file out of the test profile
  # coveralls is not installed
end
