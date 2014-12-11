class NotificationsController < ApplicationController
  load_and_authorize_resource class: Notification

  def index
    @notifications = current_user.notifications
    respond_with(@notifications)
  end

  def destroy
    @notification = current_user.notifications.find(params[:id])
    if @notification.type == 'message'
      Message.where(from_id: current_user.id, to_id: @notification.from_id).update_all(from_deleted: true)
      Message.where(to_id: current_user.id, from_id: @notification.from_id).update_all(to_deleted: true)
    end
    @notification.destroy
    respond_with(@notification)
  end
end
