require 'yaml'
require 'slop'
require 'colorize'

module GenerateComposer
  def generate(port)
    port ||= 80
    network_name = "app-#{port}"

    puts "Generating new docker-compose.yml for port #{port}".on_blue

    services = {
      service1: { nodes: 1, port: 3000 },
      service2: { nodes: 1, port: 3000 }
    }

    compose_yaml = YAML.load_file('docker-compose-template.yml')
    compose_yaml['services']['router']['links'] = []

    upstreams = {}

    services.each do |key, service_info|
      service_nodes = service_info[:nodes]
      key = key.to_s
      service_nodes.times do |node|
        base_node = compose_yaml['services'][key]
        node_name = "#{key}-#{node}-#{port}"
        compose_yaml['services'][node_name] = compose_yaml['services'][key].clone
        compose_yaml['services'].delete(key)
        compose_yaml['services']['router']['links'] << "#{node_name}:#{node_name}"
        upstreams[key] ||= []
        upstreams[key] << "#{node_name}:#{service_info[:port]}"

        compose_yaml['services'][node_name]['networks'] = [network_name]
        compose_yaml['services'][node_name]['networks'].flatten!
      end
    end
    compose_yaml['services']['router']['ports'] = ["#{port}:80"]
    compose_yaml['services']['router']['networks'] = ["app-#{port}"]
    compose_yaml['services']["nginx_#{port}"] = compose_yaml['services']['router']
    compose_yaml['services'].delete('router')

    compose_yaml['networks'] = ["#{network_name}:"]
    compose_yaml['networks'].flatten!

    compose_yaml = compose_yaml.to_yaml
    compose_yaml = compose_yaml.gsub(/- 'app-(.+[0-9]):'/, '  app-\1:')

    File.open('docker-compose.yml', 'w') { |f| f.write compose_yaml }

    generate_nginxconf(upstreams)
  end

  def generate_nginxconf(upstreams)
    nginx_conf_content = File.read("#{File.dirname(__FILE__)}/router/nginx_template.conf")

    upstreams.each do |k, v|
      nginx_conf_content = nginx_conf_content.gsub("%{#{k}}", 'server ' + v.join(";\r\n") + ';')
    end

    File.open("#{File.dirname(__FILE__)}/router/nginx.conf", 'w') { |file| file.write(nginx_conf_content) }
  end
end

include GenerateComposer

@opts = Slop.parse do |o|
  o.integer '-p', '--port', 'port', default: 80
end

generate @opts['port']
