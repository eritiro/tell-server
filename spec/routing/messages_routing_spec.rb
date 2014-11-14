require "spec_helper"

describe MessagesController do
  describe "routing" do

    it "routes to #index" do
      get("/users/1/messages").should route_to("messages#index", user_id: "1")
    end

    it "routes to #new" do
      get("/users/1/messages/new").should route_to("messages#new", user_id: "1")
    end

    it "routes to #show" do
      get("/users/1/messages/2").should route_to("messages#show", user_id: "1", id: "2")
    end

    it "routes to #edit" do
      get("/users/1/messages/2/edit").should route_to("messages#edit", user_id: "1", id: "2")
    end

    it "routes to #create" do
      post("/users/1/messages").should route_to("messages#create", user_id: "1")
    end

    it "routes to #update" do
      put("/users/1/messages/2").should route_to("messages#update", user_id: "1", id: "2")
    end

    it "routes to #destroy" do
      delete("/users/1/messages/2").should route_to("messages#destroy", user_id: "1", id: "2")
    end

  end
end
