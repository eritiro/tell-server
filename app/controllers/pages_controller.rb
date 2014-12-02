class PagesController < ActionController::Base

  def index
    @link = APP_CONFIG["download_link"]
  end

  def privacy
  end

  def download
    Event.log_without_user 'landing', request.remote_ip, request.env['HTTP_USER_AGENT']
    redirect_to APP_CONFIG["download_link"]
  end
end