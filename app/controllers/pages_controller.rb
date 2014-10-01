class PagesController < ActionController::Base

  def index
    Event.log_without_user 'landing', request.remote_ip
  end

  def landing

  end
end