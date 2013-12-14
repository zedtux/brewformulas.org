set :application, 'brewformulas-org'
set :repo_url, 'https://github.com/zedtux/brewformulas.org.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :user, 'brewformulas'
set :deploy_to, '/home/brewformulas/brewformulas.org'
set :use_sudo, false
set :ssh_options, forward_agent: true
set :runner, 'brewformulas'
set :app_server, :puma

# set :deploy_to, '/var/www/my_app'
set :scm, :git
set :deploy_via, :copy # Always get a full copy from the remote repo
set :keep_releases, 5

# set :format, :pretty
# set :log_level, :debug
set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache
#                      tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

# namespace :deploy do

# desc 'Restart application'
# task :restart do
# on roles(:app), in: :sequence, wait: 5 do
# # Your restart mechanism here, for example:
# # execute :touch, release_path.join('tmp/restart.txt')
# end
# end

# after :restart, :clear_cache do
# on roles(:web), in: :groups, limit: 3, wait: 10 do
# # Here we can do anything such as:
# # within release_path do
# # execute :rake, 'cache:clear'
# # end
# end
# end

# after :finishing, 'deploy:cleanup'

# end

##
## Puma
##
# set :shared_children, shared_children << "tmp/sockets"

puma_sock = "unix://#{shared_path}/sockets/puma.sock"
puma_control = "unix://#{shared_path}/sockets/pumactl.sock"
puma_state = "#{shared_path}/sockets/puma.state"

namespace :deploy do
  desc 'Start the application'
  task :start do
    on roles(:app) do
      current_stage = fetch(:stage)
      puma_log = "#{shared_path}/log/puma-#{fetch(:stage)}.log"
      execute <<-eos
        cd #{current_path} &&
        bundle exec puma
        -b '#{puma_sock}'
        -e #{current_stage}
        -t2:4 --control '#{puma_control}'
        -S #{puma_state} >> #{puma_log} 2>&1 &", pty: false
      eos
    end
  end

  desc 'Stop the application'
  task :stop do
    on roles(:app) do
      execute <<-eos
        cd #{current_path} &&
        bundle exec pumactl -S #{puma_state} stop
      eos
    end
  end

  desc 'Restart the application'
  task :restart do
    on roles(:app) do
      execute <<-eos
        cd #{current_path} &&
        bundle exec pumactl -S #{puma_state} restart
      eos
    end
  end

  desc 'Status of the application'
  task :status do
    on roles(:app) do
      execute <<-eos
        cd #{current_path} &&
        bundle exec pumactl -S #{puma_state} stats
      eos
    end
  end
end

##
## Application symbolic links
##
namespace :brewformulas do
  task :symlink do
    on roles(:all) do
      within release_path do
        app_config = "#{shared_path}/prod_app_config.yml"
        app_config_dest = "#{release_path}/config/production.appconfig.yml"
        database_destination = "#{release_path}/config/database.yml"
        newrelic_destination = "#{release_path}/config/newrelic.yml"

        execute :rm, "-rf #{release_path}/log"
        execute :ln, "-nfs #{shared_path}/log #{release_path}"
        execute :ln, "-nfs #{app_config} #{app_config_dest}"
        execute :ln, "-nfs #{shared_path}/database.yml #{database_destination}"
        execute :ln, "-nfs #{shared_path}/newrelic.yml #{newrelic_destination}"
      end
    end
  end
end
after 'bundler:install', 'brewformulas:symlink'
