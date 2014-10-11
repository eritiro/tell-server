class PagesController < ActionController::Base

  def index
  end

  def land
    Event.log_without_user 'landing', request.remote_ip
    head :no_content
  end
end