require 'spec_helper'

describe MessagesController do
  let(:current_user){ create(:user) }
  let(:friend){ create(:user) }
  before { sign_in current_user }

  describe "GET index" do
    it "includes sent messages in @messages" do
      message = create :message, from: current_user, to: friend
      get :index, user_id: friend.to_param
      assigns(:messages).should include(message)
    end

    it "includes received messages in @messages" do
      message = create :message, from: friend, to: current_user
      get :index, user_id: friend.to_param
      assigns(:messages).should include(message)
    end

    it "does not include messages from others" do
      message = create :message, to: current_user
      get :index, user_id: friend.to_param
      assigns(:messages).should_not include(message)
    end

    it "does not include messages to others" do
      message = create :message, from: current_user
      get :index, user_id: friend.to_param
      assigns(:messages).should_not include(message)
    end
  end

  describe "GET show" do
    it "assigns the requested message as @message" do
      message = create :message, from: friend, to: current_user
      get :show, {:id => message.to_param, user_id: friend.to_param}
      assigns(:message).should eq(message)
    end
  end

  describe "GET new" do
    it "assigns a new message as @message" do
      get :new, user_id: friend.to_param
      assigns(:message).should be_a_new(Message)
    end
  end

  describe "GET edit" do
    it "assigns the requested message as @message" do
      message = create :message, from: current_user, to: friend
      get :edit, {:id => message.to_param, user_id: friend.to_param}
      assigns(:message).should eq(message)
    end
  end

  describe "POST create" do
    it "creates a new Message" do
      expect {
        post :create, {:message => attributes_for(:message), user_id: friend.to_param}
      }.to change(Message, :count).by(1)
    end

    it "assigns a newly created message as @message" do
      post :create, {:message => attributes_for(:message), user_id: friend.to_param}
      assigns(:message).should be_a(Message)
      assigns(:message).should be_persisted
    end

    it "associates newly created message with current_user and friend" do
      post :create, {:message => attributes_for(:message), user_id: friend.to_param}
      assigns(:message).from.should eq(current_user)
      assigns(:message).to.should eq(friend)
    end

    it "redirects to the created message" do
      post :create, {:message => attributes_for(:message), user_id: friend.to_param}
      response.should redirect_to([friend, Message.last])
    end
  end

  describe "PUT update" do
    it "updates the requested message" do
      message = create :message, from: current_user, to: friend
      # Assuming there are no other messages in the database, this
      # specifies that the Message created on the previous line
      # receives the :update_attributes message with whatever params are
      # submitted in the request.
      Message.any_instance.should_receive(:update).with({ text: "Hola" })
      put :update, {:id => message.to_param, :message => { "text" => "Hola" }, user_id: friend.to_param}
    end

    it "assigns the requested message as @message" do
      message = create :message, from: current_user, to: friend
      put :update, {:id => message.to_param, :message => attributes_for(:message), user_id: friend.to_param}
      assigns(:message).should eq(message)
    end

    it "redirects to the message" do
      message = create :message, from: current_user, to: friend
      put :update, {:id => message.to_param, :message => attributes_for(:message), user_id: friend.to_param}
      response.should redirect_to([friend, message])
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested message" do
      message = create :message, from: current_user, to: friend
      expect {
        delete :destroy, {:id => message.to_param, user_id: friend.to_param}
      }.to change(Message, :count).by(-1)
    end

    it "redirects to the messages list" do
      message = create :message, from: current_user, to: friend
      delete :destroy, {:id => message.to_param, user_id: friend.to_param}
      response.should redirect_to(user_messages_url(friend))
    end
  end

end
