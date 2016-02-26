require 'fileutils'
require 'open3'

class SiteGeneratorWorker
  include Sidekiq::Worker

  def perform(site_id)
    site = Site.find(site_id)
    Dir.mktmpdir do |directory|
      fetch_source(site, directory)
      compile_site(site, directory)
    end
  end

  def fetch_source(site, tmp_dir)
    Rugged::Repository.clone_at(site.vcs_url, tmp_dir)
  end

  def compile_site(site, tmp_dir)
    destination = "#{srv_prefix}/#{site.domain_name}"
    FileUtils.rm_r(destination) if Dir.exist?(destination)
    stdin, stdout, stderr = Open3.popen3("jekyll build --source #{tmp_dir} --destination #{destination}")
    Sidekiq.logger.info "stdout: #{stdout.read}"
    Sidekiq.logger.info "stderr: #{stderr.read}"
  end

  private
  def srv_prefix
    if Rails.env.production?
      '/srv'
    else
      "#{ENV['HOME']}/tmp/srv"
    end
  end
end
