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
end
