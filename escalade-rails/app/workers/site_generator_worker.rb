require 'fileutils'
require 'open3'

class SiteGeneratorWorker
  include Sidekiq::Worker

  def perform(site_id)
    site = Site.find(site_id)
    compile_site(site)
    publish_site(site)
  end

  def compile_site(site)
    Dir.mktmpdir do |directory|
      fetch_source(site, directory)
      build_site(site, directory)
    end
  end

  def fetch_source(site, tmp_dir)
    Rugged::Repository.clone_at(site.vcs_url, tmp_dir)
  end

  def build_site(site, tmp_dir)
    destination = "#{srv_prefix}/#{site.domain_name}"
    FileUtils.rm_r(destination) if Dir.exist?(destination)
    stdin, stdout, stderr = Open3.popen3("jekyll build --source #{tmp_dir} --destination #{destination}")
    Sidekiq.logger.info "stdout: #{stdout.read}"
    Sidekiq.logger.info "stderr: #{stderr.read}"
  end

  def publish_site(site)

    #TODO: Maybe do this on a per-site basis, now?
    CaddyfileGeneratorWorker.perform_async
  end

  private
  def srv_prefix
    '/srv/sites'
  end
end
