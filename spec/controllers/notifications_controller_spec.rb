require 'spec_helper'

describe NotificationsController do
  let(:current_user){ create(:user) }
  before { sign_in current_user }

  describe "GET index" do
    it "assigns all notifications to the user as @notifications in descending order" do
      first_notification = create(:notification, to: current_user)
      last_notification = create(:notification, to: current_user)
      get :index
      assigns(:notifications).should eq [last_notification, first_notification]
    end

    it "does not includes notifications for other users" do
      notification = create(:notification)
      get :index
      assigns(:notifications).should_not include notification
    end

    describe ".json" do
      render_views
      include ApplicationHelper
      let(:json) { JSON.parse(response.body) }

      it "renders current user messages" do
        notification = create(:notification, to: current_user)
        get :index, { format: :json, api_version: 2 }

        json.first["id"].should eq notification.id
        json.first["title"].should eq notification.title
        json.first["text"].should eq notification.text
        json.first["type"].should eq notification.type
        json.first["from"]["id"].should eq notification.from.id
        json.first["from"]["username"].should eq notification.from.username
        json.first["from"]["thumb"].should eq absolute_url(notification.from.picture(:icon))

        json.first["created_at"].should eq notification.reload.created_at.as_json
        json.first["read"].should eq false
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested notification" do
      notification = create :notification, to: current_user
      expect {
        delete :destroy, {:id => notification.to_param }
      }.to change(Notification, :count).by(-1)
    end

    it "hides the related messages to the user" do
      friend = create :user
      notification = create :notification, to: current_user, from: friend, type: 'message'
      from_message = create :message, from: current_user, to: friend
      to_message = create :message, from: friend, to: current_user

      delete :destroy, {:id => notification.to_param }
      from_message.reload
      to_message.reload

      from_message.from_deleted.should be_true
      from_message.to_deleted.should   be_false
      to_message.from_deleted.should   be_false
      to_message.to_deleted.should     be_true
    end

    it "does not hide message for others" do
      notification = create :notification, to: current_user, type: 'message'
      from_message = create :message, from: current_user
      to_message = create :message, to: current_user

      delete :destroy, {:id => notification.to_param }
      from_message.reload
      to_message.reload

      from_message.from_deleted.should be_false
      from_message.to_deleted.should   be_false
      to_message.from_deleted.should   be_false
      to_message.to_deleted.should     be_false
    end

    context "of other user" do
      it "does not destroy the notification" do
        notification = create :notification
        expect {
          expect {
            delete :destroy, {:id => notification.to_param }
          }.to raise_error
        }.to change(Notification, :count).by(0)
      end
    end

    it "redirects to the messages list" do
      notification = create :notification, to: current_user
      delete :destroy, {:id => notification.to_param }
      response.should redirect_to(notifications_url)
    end
  end
end
