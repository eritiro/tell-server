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

    it "marks notifications as read" do
      notification = create(:notification, to: current_user)
      get :index
      notification.reload.read.should be_true
    end

    describe ".json" do
      render_views
      include ApplicationHelper
      let(:json) { JSON.parse(response.body) }

      it "renders current user messages" do
        notification = create(:notification, to: current_user)
        get :index, format: :json

        json.first["id"].should eq notification.id
        json.first["text"].should eq notification.text
        json.first["type"].should eq notification.type
        json.first["from_id"].should eq notification.from_id
        json.first["created_at"].should eq notification.reload.created_at.as_json
        json.first["read"].should eq false
      end
    end
  end
end
