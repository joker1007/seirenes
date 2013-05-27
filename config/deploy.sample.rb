## Bundler
require "bundler/capistrano"

set :application, "seirenes"
set :repository,  "git@github.com:joker1007/seirenes.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :scm, :git
set :user, "joker"

set :branch, 'master'
set :git_enable_submodules, 1

role :web, "anubis"                          # Your HTTP server, Apache/etc
role :app, "anubis"                          # This may be the same as your `Web` server
role :db,  "anubis", :primary => true # This is where Rails migrations will run
role :solr, "anubis"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

set :deploy_to, "/home/joker/rails_apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

default_run_options[:pty] = true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end


namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path} && BUNDLE_GEMFILE=#{File.join(current_path, "Gemfile")} bundle exec unicorn_rails -D -E production -c config/unicorn.rb"
  end
  task :stop, :roles => :app do
    run "if [ -f #{shared_path}/pids/unicorn.pid ]; then kill -s QUIT `cat #{shared_path}/pids/unicorn.pid`; fi"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{shared_path}/pids/unicorn.pid`"
  end
  task :full_restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

  task :solr_setup, :roles => :app do
    run "cd #{current_path} && ci/solr_setup"
  end

  task :ffmpeg_setup, :roles => :app do
    run "cd #{current_path} && ci/install_ffmpeg"
  end
end

namespace :config do
  task :setup, :except => {:no_release => true } do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/contrib"
    run "mkdir -p #{shared_path}/solr/data_production"
    run "mkdir -p #{shared_path}/ffmpeg"
    run "mkdir -p #{shared_path}/videos"
    run "mkdir -p #{shared_path}/audios"
    upload("config/database.yml", "#{shared_path}/config/database.yml")
    upload("config/resque.yml", "#{shared_path}/config/resque.yml")
    upload("config/settings.yml", "#{shared_path}/config/settings.yml")
    upload("config/sunspot.yml", "#{shared_path}/config/sunspot.yml")
  end

  task :symlink, :except => { :no_release => true } do
    run "ln -fs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -fs #{shared_path}/config/resque.yml #{release_path}/config/resque.yml"
    run "ln -fs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml"
    run "ln -fs #{shared_path}/config/sunspot.yml #{release_path}/config/sunspot.yml"
    run "ln -fs #{shared_path}/public/assets #{release_path}/public/assets"
    run "ln -fs #{shared_path}/contrib #{release_path}/contrib"
    run "ln -fs #{shared_path}/ffmpeg #{release_path}/ffmpeg"
    run "ln -fs #{shared_path}/videos #{release_path}/public/videos"
    run "ln -fs #{shared_path}/audios #{release_path}/public/audios"
    run "ln -fs #{shared_path}/solr/data_production #{release_path}/solr41/sunspot/data_production"
  end
end

namespace :solr_task do
  task :start, :roles => :solr do
    run "cd #{current_path} && bundle exec rake sunspot:solr:start RAILS_ENV=production"
  end
  task :stop, :roles => :solr do
    run "cd #{current_path} && bundle exec rake sunspot:solr:stop RAILS_ENV=production"
  end
  task :restart, :roles => :solr do
    stop
    start
  end
end

namespace :resque do
  task :start, :roles => :app do
    run "cd #{current_path} && PATH=#{current_path}/ffmpeg/bin:$PATH QUEUE=seirenes PIDFILE=tmp/pids/resque-worker.pid BACKGROUND=yes bundle exec rake resque:work RAILS_ENV=production"
  end
  task :stop, :roles => :app do
    run "cd #{current_path} && kill `cat tmp/pids/resque-worker.pid`"
  end
  task :restart, :roles => :app do
    stop
    start
  end
end

desc "task=command runs rake 'command' on application servers"
task :raketask, :roles => [:app] do
  if ENV['task']
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake #{ENV['task']}"
  else
    # FIXME use logger instead of warn?
    warn "USAGE: cap raketask task=..."
  end
end

namespace :app do
  task :logview, :roles => :app do
    trap("INT") { puts 'Interupted'; exit 0; }
    ENV['n'] ||= '20'
    run "tail -n #{ENV['n']} -f #{shared_path}/log/production.log" do |channel, stream, data|
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end
end

after "deploy:setup", "config:setup"
after "deploy:finalize_update", "config:symlink"
