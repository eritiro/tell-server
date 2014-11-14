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
