require "spec_helper"

describe NotificationsController do
  describe "routing" do
    it "routes to #index" do
      get("/notifications").should route_to("notifications#index")
    end
  end
end
