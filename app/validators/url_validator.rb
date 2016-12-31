class UrlValidator < ActiveModel::Validator
  def validate(record)
    url_column = options[:field]
    uri = URI(record.send(url_column))
    Net::HTTP.start(uri.host,
                    uri.port,
                    use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Head.new uri
      response = http.request request
      return response.is_a?(Net::HTTPSuccess) ||
        response.is_a?(Net::HTTPRedirection)
    end
  end
end
