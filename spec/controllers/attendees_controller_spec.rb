require 'spec_helper'

describe AttendeesController do
  let(:current_user){ create(:user) }
  before { sign_in current_user }

  describe "GET index" do
    it "assigns all location attendees as @users" do
      location = create :location
      location.attendees << create(:user)
      get :index, location_id: location.id
      assigns(:users).should eq location.attendees
    end

    describe ".json" do
      render_views
      include ApplicationHelper
      let(:json) { JSON.parse(response.body) }

      it "renders users attributes" do
        user = create(:user)
        location = create(:location)
        location.attendees << user
        get :index, location_id: location, format: "json"

        json.first["id"].should eq user.id
        json.first["username"].should eq user.username
        json.first["gender"].should eq user.gender
        json.first["picture"].should eq absolute_url(user.picture.url(:thumb))
      end
    end
  end

  describe "PUT attend" do
    it "adds current_user to location attendees" do
      location = create :location
      put :attend, location_id: location.id
      location.attendees.should include(current_user)
    end
  end

  describe "DELETE leave" do
    it "removes current_user from location attendees" do
      location = create :location
      location.attendees << current_user

      delete :leave, location_id: location.id
      location.attendees.should_not include(current_user)
    end
  end
end
