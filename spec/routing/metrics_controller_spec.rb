require "spec_helper"

describe MetricsController do
  describe "routing" do
    it "routes to #index" do
      get("/metrics").should route_to("metrics#index")
    end
  end
end
