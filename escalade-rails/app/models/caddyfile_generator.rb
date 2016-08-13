class CaddyfileGenerator

  CONFIG_TEMPLATE = File.read(File.join(Rails.root, "lib", "caddy", "templates", "Caddyfile.erb")).freeze
  SITE_TEMPLATE = File.read(File.join(Rails.root, "lib", "caddy", "templates", "site_config.erb")).freeze

  def generate
    caddyfile = render_caddyfile
    write_caddyfile(caddyfile)

    FileUtils.mkdir(caddy_site_config_path) if !File.exist?(caddy_site_config_path)
    Site.all.each do |site|
      configuration = render_site_configuration(site)
      write_site_configuration(site, configuration)
    end
  end

  def render_caddyfile
    template = Erubis::Eruby.new(CONFIG_TEMPLATE)
    template.result(
      caddy_domain_name: caddy_domain_name,
      caddy_port: caddy_port,
      caddy_log_path: caddy_log_path,
      caddy_tls_email_address: caddy_tls_email_address,
      caddy_serving_dir: caddy_serving_dir,
      caddy_config_path: caddy_config_path,
      caddy_sites_path: caddy_sites_path,
      escalade_host: escalade_host,
      escalade_port: escalade_port,
      escalade_public_dir: escalade_public_dir
    )
  end

  def render_site_configuration(site)
    template = Erubis::Eruby.new(SITE_TEMPLATE)
    configuration = template.result(
      site_domain_name: site.domain_name,
      site_port: caddy_port,
      site_tls_email_address: site_tls_email_address(site),
      site_root: site_root(site),
      site_log_path: site_log_path(site)
    )
  end

  def write_site_configuration(site, configuration)
    File.open(site_configuration_file_path(site), "w") do |file|
      file.puts(configuration)
    end
  end

  def site_configuration_file_path(site)
    File.join(caddy_site_config_path, site.domain_name)
  end

  def caddy_site_config_path
    File.join(caddy_config_path, "sites")
  end

  def write_caddyfile(configuration)
    File.open(caddyfile_path, "w") do |file|
      file.puts configuration
    end
  end

  def caddy_config_path
    File.join(caddy_path, "config")
  end

  def site_root(site)
    File.join(caddy_serving_dir, site.domain_name)
  end

  def site_tls_email_address(site)
    Rails.env.production? ? site.user.email : caddy_tls_email_address
  end

  def site_log_path(site)
    "/dev/stdout"
  end

  def caddy_serving_dir
    ENV.fetch("CADDY_SERVING_DIR") { File.join("/", "srv", "sites") }
  end

  def caddyfile_path
    ENV.fetch("CADDYFILE_PATH") { File.join(caddy_config_path, "Caddyfile") }
  end

  def caddy_path
    ENV.fetch("CADDY_PATH") { File.join("/", "srv", "escalade", "caddy") }
  end

  def caddy_domain_name
    ENV.fetch("CADDY_DOMAIN_NAME") { "escalade" }
  end

  def caddy_port
    ENV.fetch("CADDY_PORT") { "80" }
  end

  def caddy_log_path
    ENV.fetch("CADDY_LOG_PATH") { "/dev/stdout" }
  end

  def caddy_tls_email_address
    ENV.fetch("CADDY_TLS_EMAIL_ADDRESS") { "off" }
  end

  def caddy_sites_path
    ENV.fetch("CADDY_SITES_PATH") { File.join(caddy_config_path, "sites", "*") }
  end

  def escalade_host
    ENV.fetch("ESCALADE_HOST") { "escalade-rails" }
  end

  def escalade_port
    ENV.fetch("ESCALADE_PORT") { "3000" }
  end

  def escalade_public_dir
    ENV.fetch("ESCALADE_PUBLIC_DIR") { File.join("/", "srv", "escalade-rails", "current", "public") }
  end
end
