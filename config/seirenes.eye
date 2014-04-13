require 'eye'

RAILS_ENV = ENV['RAILS_ENV'] || 'production'

Eye.config do
  logger File.expand_path('../../log/eye.log', __FILE__)
end

Eye.application 'seirenes' do
  working_dir File.expand_path('../../', __FILE__)
  stdall 'log/stdall.log'
  env 'RAILS_ENV' => RAILS_ENV

  process :unicorn do
    pid_file 'tmp/pids/unicorn.pid'
    start_command "bundle exec unicorn -c config/unicorn.rb -D -E #{RAILS_ENV}"
    restart_command "kill -USR2 {PID}"
    stop_signals [:QUIT, 5.seconds, :TERM, 1.seconds, :KILL]

    check :cpu,    every: 30.seconds, below: 80, times: 3
    check :memory, every: 30.seconds, below: 400.megabytes, times: [3, 5]

    start_timeout 15.seconds
    restart_grace 15.seconds

    check :http, url: 'http://127.0.0.1:8000/check', pattern: /seirenes/, every: 15.seconds,
      times: [3, 5], timeout: 3.seconds

    monitor_children do
      stop_command "kill -QUIT {PID}"
      check :cpu,    every: 30.seconds, below: 80, times: 3
      check :memory, every: 30.seconds, below: 400.megabytes, times: [3, 5]
    end
  end

  process :sidekiq do
    pid_file "tmp/pids/sidekiq.pid"
    start_command "bundle exec sidekiq -c 2 -q seirenes -e #{RAILS_ENV} -P tmp/pids/sidekiq.pid"
    stdall "log/sidekiq.log"
    daemonize true
    stop_signals [:QUIT, 5.seconds, :TERM, 5.seconds, :KILL]

    check :memory, every: 30.seconds, below: 400.megabytes, times: [3, 5]
  end

  process :clockwork do
    pid_file "tmp/pids/clockworkd.clockwork.pid"
    start_command "bundle exec clockworkd -c config/clockwork.rb --pid-dir=tmp/pids --log --log-dir=log start"
    stop_command "bundle exec clockworkd -c config/clockwork.rb --pid-dir=tmp/pids --log --log-dir=log stop"
    restart_command "bundle exec clockworkd -c config/clockwork.rb --pid-dir=tmp/pids --log --log-dir=log restart"
    check :memory, every: 30.seconds, below: 400.megabytes, times: [3, 5]
  end
end

# vim:ft=ruby
