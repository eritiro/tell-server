require "spec_helper"

describe PagesController do
  describe "routing" do
    it "routes to #index" do
      get("/").should route_to("pages#index")
    end

    it "routes to #privacy" do
      get("/privacy").should route_to("pages#privacy")
    end

    it "app routes to #download" do
      get("/app").should route_to("pages#download")
    end

    it "routes to #download" do
      get("/download").should route_to("pages#download")
    end
  end
end
