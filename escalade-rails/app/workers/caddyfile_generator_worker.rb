class CaddyfileGeneratorWorker
  include Sidekiq::Worker

  def perform
    generate_site_configuration
    reload_caddy_configuration
  end

  def generate_site_configuration
    CaddyfileGenerator.new.generate
  end

  def reload_caddy_configuration
    CaddyReloadWorker.perform_async
  end
end
