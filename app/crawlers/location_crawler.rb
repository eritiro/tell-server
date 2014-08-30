class LocationCrawler
  require 'open-uri'
  require 'nokogiri'

  class AfipPageError < StandardError
  end


  def get_location(afip_url)
    location = Location.new(afip_url: afip_url)
    OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = 'SSLv3'
    unparsed = open(afip_url)
    doc = Nokogiri::HTML(unparsed)
    if doc.css('#lblMensaje').present?
      raise AfipPageError.new("AFIP Message: #{doc.css('#lblMensaje').text}")
    end
    location.name = doc.css("h3").text
    location.address =  doc.css(".bandeja td")[9].text
    location
  end
end