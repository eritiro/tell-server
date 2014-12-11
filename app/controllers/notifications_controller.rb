class NotificationsController < ApplicationController
  load_and_authorize_resource class: Notification

  def index
    @notifications = current_user.notifications
    respond_with(@notifications)
  end

  def destroy
    @message = current_user.notifications.find(params[:id])
    @message.destroy
    respond_with(@message)
  end
end
