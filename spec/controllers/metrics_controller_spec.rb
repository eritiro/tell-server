require 'spec_helper'

describe MetricsController do
  before { sign_in create(:admin) }

  describe "GET index" do
    it "assigns all versions as @versions" do
      create :version
      get :index, {}
      assigns(:versions).should eq Version.all
    end

    it "has one row per event_type" do
      get :index, {}
      assigns(:events).map{|event| event[:key] }.should eq Event::TYPES
    end

    it "counts only real users" do
      create :user
      create :user, :fake
      get :index, {}
      assigns(:users_count).should eq(1)
    end

    describe "locations" do
      it "assigns locations with attendees" do
        location_with_attendee = create :location
        location_without_attendee = create :location
        create :user, location: location_with_attendee

        get :index, {}

        assigns(:locations).should eq([location_with_attendee])
      end

      it "orders locations by attendees" do
        location = create :location
        popular_location = create :location

        create_list :user, 1, location: location
        create_list :user, 2, location: popular_location

        get :index, {}

        assigns(:locations).should eq([popular_location, location])
      end

      it "does not count fake users" do
        location = create :location
        create :user, :fake, location: location

        get :index, {}

        assigns(:locations).should_not include(location)
      end
    end

    describe "with landing data" do
      it "counts TYPES" do
        create :version

        create_list :event, 8, :landing
        create_list :event, 6, :registration
        create_list :event, 3, :attend

        get :index, {}
        assigns(:events).map{|event| event[:values] }.should eq [
          [{accumulated: 100, compared: nil}],
          [{accumulated: 75, compared: 25}],
          [{accumulated: 37, compared: 50}],
          [{accumulated: 0, compared: 100}]]
      end
    end
  end
end