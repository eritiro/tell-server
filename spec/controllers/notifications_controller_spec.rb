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
        json.first["from"]["thumb"].should eq notification.from.picture(:thumb)

        json.first["created_at"].should eq notification.reload.created_at.as_json
        json.first["read"].should eq false
      end
    end
  end
end
