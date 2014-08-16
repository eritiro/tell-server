module ApplicationHelper
  def absolute_url(url)
    URI::join(APP_CONFIG['host'], url).to_s
  end
end
