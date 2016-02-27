class CaddyfileGenerator

  CONFIG_TEMPLATE = <<~EOS
    tlspages.adamvduke.com {
      root <%= File.join(serving_dir, "escalade", "escalade-rails", "public") %>
      tls adam.v.duke@gmail.com
      proxy / localhost:5000 {
        except /assets
      }
    }
    import sites/*
  EOS

  SITE_TEMPLATE = <<~EOS
    <%= site.domain_name %> {
      root <%= File.join(serving_dir, site.domain_name) %>
      tls <%= site.user.email  %>
    }
  EOS

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
    template.result(serving_dir: serving_dir)
  end

  def render_site_configuration(site)
    template = Erubis::Eruby.new(SITE_TEMPLATE)
    configuration = template.result(serving_dir: serving_dir,
                                    site: site)
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

  def serving_dir
    ENV.fetch("CADDY_SERVING_DIR") { File.join("/", "srv") }
  end

  def caddyfile_path
    ENV.fetch("CADDYFILE_PATH") { File.join(caddy_config_path, "Caddyfile") }
  end

  def caddy_config_path
    File.join(caddy_path, "config")
  end

  def caddy_path
    File.join("..", "caddy")
  end

  def archive_path(file_path)
    contents = File.read(file_path)
    digest = Digest::SHA1.hexdigest(contents)
    archive_date_time = DateTime.now
    File.join(caddy_config_archive_path, "Caddyfile-#{archive_date_time}-#{digest}")
  end

  def caddy_config_archive_path
    File.join(caddy_config_path, "archive")
  end
end
