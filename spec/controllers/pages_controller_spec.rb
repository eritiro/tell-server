require 'spec_helper'

describe PagesController do
  describe "POST land" do
    it "creates a landing event" do
      expect { post :land }.to change{ Event.count }.by(1)
      Event.last.event_type.should eq 'landing'
      Event.last.ip.should_not be_nil
      Event.last.user.should be_nil
    end
  end

  describe "GET app" do
    it "creates a landing event" do
      expect { get :app }.to change{ Event.count }.by(1)
      Event.last.event_type.should eq 'landing'
      Event.last.ip.should_not be_nil
      Event.last.user.should be_nil
    end

    it "redirects to the app" do
      expect { get :app }.to change{ Event.count }.by(1)
      response.should redirect_to(APP_CONFIG["download_link"])
    end
  end
end
