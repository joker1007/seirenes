# @param [Hash] options Any of :log, :env, :pwd, :command, :stdout_log, :stderr_log, :spawn_options, :spawn_checker, :timeout
def spawn_process(options = {})
  env = options[:env] || {}
  command = options[:command]
  stdout_log = options[:stdout_log] ? [options[:stdout_log], 'w'] : :out
  stderr_log = options[:stderr_log] ? [options[:stderr_log], 'w'] : :err
  pwd = options[:pwd]
  spawn_options = {
    :out => stdout_log,
    :err => stderr_log,
  }
  spawn_options.merge!(:chdir => pwd) if pwd
  spawn_options.merge!(options[:spawn_options]) if options[:spawn_options]
  spawn_checker = options[:spawn_checker]
  timeout_sec = options[:timeout] || 30

  ::ActiveRecord::Base.clear_all_connections!
  pid = spawn(env, command, spawn_options)
  ::ActiveRecord::Base.establish_connection

  at_exit do
    begin
      Process.kill(:SIGINT, pid)
      Process.waitpid(pid)
    rescue Errno::ESRCH, Errno::ECHILD
    end
  end

  if spawn_checker
    begin
      timeout(timeout_sec) do
        until spawn_checker.call
          Process.kill 0, pid # live check. Raise Errno::ESRCH if process died
          sleep 0.1
        end
      end
    rescue Timeout::Error, Errno::ESRCH
      STDERR.puts("Failed to start the backend program #{options.inspect}")
      if File.exist?(stdout_log)
        STDERR.puts(File.read(stdout_log))
      end
    end
  end

  pid
end
