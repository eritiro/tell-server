class PagesController < ActionController::Base

  def index
    @link = APP_CONFIG["download_link"]
  end

  def app
    Event.log_without_user 'landing', request.remote_ip
    redirect_to APP_CONFIG["download_link"]
  end

  def land
    Event.log_without_user 'landing', request.remote_ip
    head :no_content
  end
end