Jekyll::Hooks.register :site, :after_init do |site|
  require 'css_parser'
  require 'digest'
  require 'fileutils'
  require 'nokogiri'
  require 'open-uri'
  require 'uri'

  font_file_types = ['otf', 'ttf', 'woff', 'woff2']
  image_file_types = ['.gif', '.jpg', '.jpeg', '.png', '.webp']

  # Método para descargar y cambiar la URL de una regla de CSS
  def download_and_change_rule_set_url(rule_set, rule, dest, dirname, config, file_types)
    return unless rule_set[rule].include?('url(')

    url = rule_set[rule].split('url(').last.split(')').first
    url = url[1..-2] if url.start_with?('"') || url.start_with?("'")

    file_name = url.split('/').last.split('?').first
    return unless file_name.end_with?(*file_types)

    url = URI.join(url, url).to_s unless url.start_with?('https://')
    download_file(url, File.join(dest, file_name))

    previous_rule = rule_set[rule]
    base_path = config['baseurl'] ? File.join(config['baseurl'], 'assets', 'libs', dirname, file_name) : File.join('/assets', 'libs', dirname, file_name)

    if rule_set[rule].split(' ').length > 1
      rule_set[rule] = "url(#{base_path}) #{rule_set[rule].split(' ').last}"
    else
      rule_set[rule] = "url(#{base_path})"
    end
    puts "Changed #{previous_rule} to #{rule_set[rule]}"
  end

  # Método para descargar un archivo
  def download_file(url, dest)
    return if url.start_with?('|')

    dir = File.dirname(dest)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    unless File.file?(dest)
      puts "Downloading #{url} to #{dest}"
      File.open(dest, "wb") do |saved_file|
        URI.open(url, "rb") do |read_file|
          saved_file.write(read_file.read)
        end
      end
      raise "Failed to download #{url} to #{dest}" unless File.file?(dest)
    end
  end

  # Reemplazar {{version}} con el número de versión en todas las URLs de bibliotecas externas
  site.config['third_party_libraries']&.each do |key, value|
    next if key == 'download' || value['url'].nil?

    value['url'].each do |type, url|
      if url.is_a?(Hash)
        url.each do |type2, url2|
          if url2.include?('{{version}}')
            value['url'][type][type2] = url2.gsub('{{version}}', value['version'])
          end
        end
      elsif url.include?('{{version}}')
        value['url'][type] = url.gsub('{{version}}', value['version'])
      end
    end
  end

  # Descargar bibliotecas externas si está habilitado
  if site.config['third_party_libraries'] && site.config['third_party_libraries']['download']
    site.config['third_party_libraries'].each do |key, value|
      next if key == 'download' || value['url'].nil?

      value['url'].each do |type, url|
        next if url.nil?

        if url.is_a?(Hash)
          url.each do |type2, url2|
            next if url2.nil?

            file_name = url2.split('/').last.split('?').first
            dest = File.join(site.source, 'assets', 'libs', key, file_name)
            download_file(url2, dest)

            base_path = site.config['baseurl'] ? File.join(site.config['baseurl'], 'assets', 'libs', key, file_name) : File.join('/assets', 'libs', key, file_name)
            value['url'][type][type2] = base_path
          end
        else
          file_name = url.split('/').last.split('?').first
          dest = File.join(site.source, 'assets', 'libs', key, file_name)
          download_file(url, dest)

          base_path = site.config['baseurl'] ? File.join(site.config['baseurl'], 'assets', 'libs', key, file_name) : File.join('/assets', 'libs', key, file_name)
          value['url'][type] = base_path
        end
      end
    end
  end
end
