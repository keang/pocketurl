# UrlValidator checks if a given field is a valid url, i.e. live
# url.
#
# The attribute to be checked should be passed in as +:field+
# option, for example:
#
#   class MyModel < ApplicationRecord
#     validates_with UrlValidator, field: :my_url
#   end
#
class UrlValidator < ActiveModel::Validator
  VALID_CLASSES = [Net::HTTPSuccess, Net::HTTPRedirection]

  # Tries to make a HEAD request to the url found in the
  # given field.
  #
  # Responses of codes 200, 301 and 302 (Net::HTTPSuccess and
  # Net::HTTPRedirection) are accepted as valid urls.
  #
  def validate(record)
    url_column = options[:field]
    uri = URI(record.send(url_column))
    Net::HTTP.start(uri.host,
                    uri.port,
                    use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Head.new uri
      response = http.request request

      is_valid(response).tap do |valid|
        record.errors[url_column] << (options[:message] || "is an invalid URL") unless valid
      end
    end
  end

  def is_valid(response)
    VALID_CLASSES.any? { |klass| response.is_a? klass }
  end
end
