class MessagesController < ApplicationController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @messages = scoped_messages
    respond_with(@messages)
  end

  def show
    respond_with(@message)
  end

  def new
    @message = @user.received_messages.new
    respond_with(@message)
  end

  def edit
  end

  def create
    @message = @user.received_messages.new(text: message_params["text"], from: current_user)
    @message.save
    if @user.device_token.present?
      GCM.send_notification @user.device_token, { message: @message.text, title: "#{current_user} te envió un mensaje" }
    end

    respond_with([@user, @message])
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
    Message.where(from_id: [current_user, @user], to_id: [current_user, @user])
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
