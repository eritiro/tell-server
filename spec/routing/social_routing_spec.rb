require "spec_helper"

describe RegistrationsController do
  describe "routing" do
    it "routes to #create" do
      put("/users/facebook").should route_to("social#facebook")
    end
  end
end
