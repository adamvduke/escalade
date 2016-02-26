class CaddyServerConfigGenerator

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
    write_configuration_file(configuration)
  end

  def render_configuration
    template = Erubis::Eruby.new(CONFIG_TEMPLATE)
    template.result(sites: Site.all.joins(:user),
                    serving_dir: serving_dir)
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
    ENV.fetch("CADDYFILE_PATH") { File.join("tmp", "Caddyfile") }
  end
end
