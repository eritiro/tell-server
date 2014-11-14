require "spec_helper"

describe AttendeesController do
  describe "routing" do

    it "routes to #index" do
      get("/locations/1/attendees").should route_to("attendees#index", location_id: "1")
    end

    it "routes to #add" do
      put("/locations/1/attendees").should route_to("attendees#attend", location_id: "1")
    end

    it "routes to #remove" do
      delete("/locations/1/attendees").should route_to("attendees#leave", location_id: "1")
    end
  end
end
