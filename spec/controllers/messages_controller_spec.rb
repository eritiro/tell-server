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

    it "does not include messages to oneself" do
      message = create :message, from: current_user, to: current_user
      get :index, user_id: friend.to_param
      assigns(:messages).should_not include(message)
    end

    it "marks notification as read" do
      notification = create(:notification, to: current_user, from: friend, type: 'message')
      get :index, user_id: friend.to_param
      notification.reload.read.should be_true
    end

    describe ".json" do
      render_views
      include ApplicationHelper
      let(:json) { JSON.parse(response.body) }

      it "renders current user messages" do
        message = create :message, from: current_user, to: friend
        get :index, user_id: friend.to_param, format: :json

        json.first["id"].should eq message.id
        json.first["text"].should eq message.text
        json.first["mine"].should be_true
        json.first["created_at"].should eq message.reload.created_at.as_json
      end

      it "renders friend messages" do
        message = create :message, from: friend, to: current_user
        get :index, user_id: friend.to_param, format: :json

        json.first["id"].should eq message.id
        json.first["text"].should eq message.text
        json.first["mine"].should be_false
        json.first["created_at"].should eq message.reload.created_at.as_json
      end
    end
  end

  describe "GET show" do
    it "assigns the requested message as @message" do
      message = create :message, from: friend, to: current_user
      get :show, {:id => message.to_param, user_id: friend.to_param}
      assigns(:message).should eq(message)
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

    context "with a very long text" do
      let(:text){ "long" * 100 }

      it "creates a message anyway" do
        expect {
          post :create, {:message => attributes_for(:message, text: text), user_id: friend.to_param}
        }.to change(Message, :count).by(1)
        Message.last.text.should start_with("long")
      end
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

    it "notifies friend and user" do
      text = "hello"
      result = []
      User.any_instance.stub(:notify){ |p| result << p }
      post :create, {:message => attributes_for(:message, text: text ), user_id: friend.to_param}
      result.count.should eq 2
      result.first.should eq({ text: text, title: "#{current_user} te envió un mensaje", type: "message", from: current_user })
      result.last.should  eq({ text: text, type: "message", from: friend, read: true })
    end

    it "logs the event" do
      Event.should_receive(:log).with('chat', current_user)
      post :create, {:message => attributes_for(:message), user_id: friend.to_param}
    end

    it "redirects to user messages" do
      post :create, {:message => attributes_for(:message), user_id: friend.to_param}
      response.should redirect_to(user_messages_url(friend))
    end

    describe ".json" do
      it "shows no content" do
        post :create, {:message => attributes_for(:message), user_id: friend.to_param, format: :json }
        response.status.should eq 204
      end
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
