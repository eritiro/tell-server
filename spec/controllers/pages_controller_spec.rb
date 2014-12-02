require 'spec_helper'

describe PagesController do
  describe "GET index" do
    render_views

    it "renders a page with a call-to-action" do
      get :index
      response.body.should include("Descargar ahora")
    end
  end

  describe "GET privacy" do
    render_views

    it "shows the privacy page" do
      get :privacy
      response.body.should include("Privacy Policy")
    end
  end

  describe "GET download" do
    it "creates a landing event" do
      expect { get :download }.to change{ Event.count }.by(1)
      Event.last.event_type.should eq 'landing'
      Event.last.ip.should_not be_nil
      Event.last.user.should be_nil
    end

    it "redirects to the app" do
      expect { get :download }.to change{ Event.count }.by(1)
      response.should redirect_to(APP_CONFIG["download_link"])
    end
  end
end
