class MessagesController < ApplicationController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @messages = scoped_messages
    @message = @user.received_messages.new
    current_user.notifications.where(from: @user, type: 'message').update_all(read: true)
    respond_with(@messages)
  end

  def show
    respond_with(@message)
  end

  def edit
  end

  def create
    @message = @user.received_messages.new(text: message_params["text"][0, 255], from: current_user)
    @message.save!

    @user.notify(
      from: current_user,
      text: @message.text,
      title: "#{current_user}",
      type: "message")

    @notification = current_user.notify(
      from: @user,
      text: @message.text,
      type: "message",
      read: true)

    Event.log 'chat', current_user

    respond_to do |format|
      format.html { redirect_to user_messages_path(@user) }
      format.json { render 'messages/show' }
    end
  end

  def update
    @message.update(text: message_params["text"])
    respond_with([@user, @message])
  end

  def destroy
    if @message.from == current_user
      @message.update(from_deleted: true)
    else
      @message.update(to_deleted: true)
    end
    respond_to do |format|
      format.html { redirect_to user_messages_path(@user) }
      format.json { head :no_content }
    end
  end

private
  def scoped_messages
    Message.where("(from_id = ? and to_id = ? and not from_deleted) or (from_id = ? and to_id = ? and not to_deleted)",
      current_user, @user,
      @user, current_user)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_message
    @message = scoped_messages.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:text)
  end
end
