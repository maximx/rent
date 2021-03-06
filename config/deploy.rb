# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'rent'
set :repo_url, 'git@github.com:maximx/rent.git'
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :stage, %w(staging production)
set :deploy_to, "/home/apps/#{fetch(:application)}"

set :linked_dirs, fetch(:linked_dirs, []).push('log')

linked_files = fetch(:linked_files, [])
linked_files << 'config/database.yml'
linked_files << 'config/fog.yml'
linked_files << 'config/facebook.yml'
linked_files << 'config/google.yml'
set :linked_files, linked_files

set :pty, true

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc 'Restart Application'
  task :restart do
    on roles(:app), in: :sequence, wait: 2 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'Restart Server'
  task :nginx_restart do
    on roles(:web), in: :sequence, wait: 1 do
      sudo "/etc/init.d/nginx restart"
    end
  end

  task :runrake do
    on roles(:all) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, ENV['task']
        end
      end
    end
  end
end
