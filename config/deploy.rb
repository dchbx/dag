# config valid only for current version of Capistrano
lock '3.5.0'

set :application, "dag"
set :repo_url, "https://github.com/dchbx/dag.git"
set :user, "nginx"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/deployments/dag'

set :bundle_binstubs, false
set :bundle_flags, "--quiet"
set :bundle_path, nil

# Default value for :pty is false
set :pty, true

set :rails_env, "production"
# Default value for :scm is :git
# set :scm, :git
# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/unicorn.rb', 'config/secrets.yml', 'eyes/dag.eye.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'pids', 'eye')

# capistrano/rails setup
set :assets_roles, [:web, :app]

namespace :assets do
  desc "Kill all the assets"
  task :refresh do
    on roles(:web) do
#      execute "rm -rf #{shared_path}/public/assets/*"
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "assets:precompile"
        end
      end
    end
  end
end
after "deploy:updated", "assets:refresh"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 20 do
      sudo "service eye_dag reload"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

end

after "deploy:publishing", "deploy:restart"
