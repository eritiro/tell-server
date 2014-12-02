class PagesController < ActionController::Base

  def index
    @link = APP_CONFIG["download_link"]
  end

  def privacy
  end

  def download
    Event.log_without_user 'landing', request.remote_ip
    redirect_to APP_CONFIG["download_link"]
  end
end