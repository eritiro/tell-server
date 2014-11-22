class MessagesController < ApplicationController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @messages = scoped_messages
    @message = @user.received_messages.new
    respond_with(@messages)
  end

  def show
    respond_with(@message)
  end

  def edit
  end

  def create
    @message = @user.received_messages.new(text: message_params["text"], from: current_user)
    @message.save!

    @user.notify(
      from: current_user,
      text: @message.text,
      title: "#{current_user} te envió un mensaje",
      type: "message")

    Event.log 'chat', current_user

    respond_to do |format|
      format.html { redirect_to user_messages_path(@user) }
      format.json { head :no_content }
    end
  end

  def update
    @message.update(text: message_params["text"])
    respond_with([@user, @message])
  end

  def destroy
    @message.destroy
    respond_with([@user, @message])
  end

private
  def scoped_messages
    Message.where("(from_id = ? and to_id = ?) or (from_id = ? and to_id = ?)",
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
