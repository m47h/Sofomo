require 'uri'
require 'net/http'
class Geoip
  DEFAULT_URI = URI.parse("https://freegeoip.app/")
  FORMATS = %w[json jsonp csv xml].freeze

  def initialize
    @http = create_connection
  end

  def search(ip_or_hostname = '', format = FORMATS.first)
    request = create_request(path(ip_or_hostname, format))
    @response = @http.request(request)
    parse_response
  end

  private

  attr_reader :response

  def create_connection
    http = Net::HTTP.new(DEFAULT_URI.host, DEFAULT_URI.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.open_timeout = 5 # in seconds
    http.read_timeout = 5 # in seconds
    http
  end

  def create_request(path)
    request = Net::HTTP::Get.new(path)
    request["accept"] = 'application/json'
    request["content-type"] = 'application/json'
    request
  end

  def parse_response
    case response.content_type
    when 'application/json'
      HashWithIndifferentAccess.new JSON.parse(response.read_body)
    else
      response.read_body
    end
  end

  def path(ip_or_hostname, format)
    "/format/ip_or_hostname".gsub('format', format).gsub('ip_or_hostname', ip_or_hostname)
  end
end

