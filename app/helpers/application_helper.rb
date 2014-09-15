module ApplicationHelper
  def absolute_url(url)
    URI::join(host, url).to_s
  end

  def host
    "http://#{APP_CONFIG['host']}"
  end
end
