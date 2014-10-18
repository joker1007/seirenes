lock '3.2.1'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.3'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :application, "seirenes"
set :repo_url,  "git@github.com:joker1007/seirenes.git"

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
set :scm, :git
set :user, "joker"

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/resque.yml config/settings.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log contrib tmp/pids tmp/cache tmp/sockets public/system public/videos node_modules bower_components}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  task :elasticsearch_setup do
    on roles(:app) do |host|
      within current_path do
        execute :sh, "./elasticsearch_setup"
      end
    end
  end

  task :ffmpeg_setup do
    on roles(:app) do |host|
      run "cd #{current_path} && ci/install_ffmpeg"
    end
  end

  namespace :npm do
    task :install do
      on roles(fetch(:assets_roles)) do
        within release_path do
          with rails_env: fetch(:rails_env), path: "#{release_path}/node_modules/.bin:$PATH" do
            execute :npm, "install"
            execute :bower, "install"
          end
        end
      end
    end
  end

  namespace :assets do
    task :gulp_build do
      on roles(fetch(:assets_roles)) do
        within release_path do
          with rails_env: fetch(:rails_env), path: "#{release_path}/node_modules/.bin:$PATH", env: "production", lang: "ja_JP.UTF-8", lc_all: "ja_JP.utf8" do
            execute :gulp
          end
        end
      end
    end
  end

  before 'deploy:assets:precompile', 'deploy:assets:gulp_build'
  before 'deploy:assets:gulp_build', 'deploy:npm:install'
end

namespace :config do
  task :setup do
    on roles(:app) do |host|
      execute :mkdir, "-p", "#{shared_path}/config"
      upload! "config/database.yml", "#{shared_path}/config/database.yml"
      upload! "config/resque.yml", "#{shared_path}/config/resque.yml"
      upload! "config/settings.yml", "#{shared_path}/config/settings.yml"
    end
  end
end

desc "task=command runs rake 'command' on application servers"
task :raketask do
  on roles(:app) do |host|
    if ENV['TASK']
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, "#{ENV['TASK']}"
        end
      end
    else
      # FIXME use logger instead of warn?
      warn "USAGE: cap raketask TASK=..."
    end
  end
end

namespace :app do
  task :logview do
    on roles(:app) do |host|
      trap("INT") { puts 'Interupted'; exit 0; }
      ENV['n'] ||= '20'
      run "tail -n #{ENV['n']} -f #{shared_path}/log/production.log" do |channel, stream, data|
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end
    end
  end
end

namespace :test do
  task :uptime do
    on roles(:all) do |host|
      execute :uptime
      info "#{host}"
    end
  end
end
