class CaddyServerConfigGeneratorWorker
  include Sidekiq::Worker

  def perform
    CaddyServerConfigGenerator.new.generate
  end
end
