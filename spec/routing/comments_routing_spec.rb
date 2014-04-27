require "spec_helper"

describe CommentsController do
  describe "routing" do

    it "routes to #index" do
      get("/locations/2/comments").should route_to("comments#index", location_id: "2")
    end

    it "routes to #new" do
      get("/locations/2/comments/new").should route_to("comments#new", location_id: "2")
    end

    it "routes to #show" do
      get("/locations/2/comments/1").should route_to("comments#show", id: "1", location_id: "2")
    end

    it "routes to #edit" do
      get("/locations/2/comments/1/edit").should route_to("comments#edit", id: "1", location_id: "2")
    end

    it "routes to #create" do
      post("/locations/2/comments").should route_to("comments#create", location_id: "2")
    end

    it "routes to #update" do
      put("/locations/2/comments/1").should route_to("comments#update", id: "1", location_id: "2")
    end

    it "routes to #destroy" do
      delete("/locations/2/comments/1").should route_to("comments#destroy", id: "1", location_id: "2")
    end

  end
end
