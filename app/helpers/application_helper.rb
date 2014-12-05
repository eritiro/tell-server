module ApplicationHelper
  def absolute_url(url)
    URI::join(host, url).to_s
  end

  def host
    "http://#{APP_CONFIG['host']}"
  end

  def data_uri attachment, style
    file = attachment.path(style)
    return nil if file.nil?
    file_contents = File.open(file) { |f| f.read }
    encoded_string = Base64.encode64(file_contents)
    mime_type = attachment.content_type
    "data:#{mime_type};base64,#{encoded_string}"
  end
end
