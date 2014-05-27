module LocationsHelper
  require 'open-uri'
  require 'nokogiri'

  def get_location(afip_req)  
    location = Location.new(afip_req: afip_req)
    unparsed = open("https://servicios1.afip.gov.ar/clavefiscal/qr/mobilePublicInfo.aspx?req=" + afip_req)
    doc = Nokogiri::HTML(unparsed)
    location.name = doc.css("h3").text
    location.address =  doc.css(".bandeja td")[9].text
    location
  end
end
