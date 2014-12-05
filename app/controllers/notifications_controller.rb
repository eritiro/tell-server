class NotificationsController < ApplicationController
  load_and_authorize_resource class: Notification

  def index
    @notifications = current_user.notifications
    respond_with(@notifications)
  end
end
