class CaddyfileGeneratorWorker
  include Sidekiq::Worker

  def perform
    CaddyfileGenerator.new.generate
  end
end
