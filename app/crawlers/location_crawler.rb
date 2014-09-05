class LocationCrawler
  require 'open-uri'
  require 'nokogiri'

  class LocationCrawlerError < StandardError
  end

  def get_location(afip_url)
    validate_url afip_url
    location = Location.new(afip_url: afip_url)
    OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = 'SSLv3'
    unparsed = open(afip_url)
    doc = Nokogiri::HTML(unparsed)
    if doc.css('#lblMensaje').present?
      raise LocationCrawlerError.new("AFIP Message: #{doc.css('#lblMensaje').text}")
    end
    location.name = doc.css("h3").text
    location.address =  doc.css(".bandeja td")[9].text
    location
  end

  def validate_url afip_url
    unless URI.parse(afip_url).kind_of?(URI::HTTPS)
      raise LocationCrawlerError.new("Invalid url: #{afip_url}")
    end
  rescue URI::InvalidURIError
    raise LocationCrawlerError.new("Invalid url: #{afip_url}")
  end
end