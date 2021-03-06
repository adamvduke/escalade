class CaddyReloadWorker
  include Sidekiq::Worker

  def perform
    pid = read_caddy_pid
    signal_reload(pid)
  end

  def read_caddy_pid
    pid = File.read(caddy_pid_file_path)
  end

  def signal_reload(caddy_pid)
    `kill -s USR1 #{caddy_pid}`
  end

  def caddy_pid_file_path
    ENV.fetch("CADDY_PID_FILE_PATH") { File.join("/", "srv", "escalade", "caddy", "pid") }
  end
end
