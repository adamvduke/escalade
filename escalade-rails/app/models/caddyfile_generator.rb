class CaddyfileGenerator

  CONFIG_TEMPLATE = <<~EOS
    tlspages.adamvduke.com {
      root <%= File.join(serving_dir, "escalade", "escalade-rails", "public") %>
      tls adam.v.duke@gmail.com
      proxy / localhost:5000 {
        except /assets
      }
    }

    <% sites.each do |site| %>
    <%= site.domain_name %> {
      root <%= File.join(serving_dir, site.domain_name) %>
      tls <%= site.user.email  %>
    }

    <% end %>
  EOS

  def generate
    configuration = render_configuration
    archive_current_configuration
    write_configuration_file(configuration)
  end

  def render_configuration
    template = Erubis::Eruby.new(CONFIG_TEMPLATE)
    template.result(sites: Site.all.joins(:user),
                    serving_dir: serving_dir)
  end

  def archive_current_configuration
    if File.exists?(caddyfile_path)
      FileUtils.mkdir(caddy_config_archive_path) if !File.exists?(caddy_config_archive_path)
      FileUtils.cp(caddyfile_path, archive_path(caddyfile_path))
    end
  end

  def write_configuration_file(configuration)
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
