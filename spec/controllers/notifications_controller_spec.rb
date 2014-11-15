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

    it "does not includes notifications to other users" do
      notification = create(:notification)
      get :index
      assigns(:notifications).should_not include notification
    end
  end
end
