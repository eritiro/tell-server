require 'spec_helper'
include Devise::TestHelpers

describe Event do
  it "has a valid factory" do
    build(:event).should be_valid
  end

  it "validates presence of user" do
    build(:event, user: nil).should_not be_valid
  end

  it "validates presence of event_type" do
    build(:event, event_type: nil).should_not be_valid
  end

  it "validates event_type is a known type" do
    build(:event, event_type: 'unknown').should_not be_valid
  end

  describe "log" do
    context "when current user is not admin" do
      context "if the event does not exists" do
        it "creates a new event" do
          user = build :user
          expect {
            Event.log 'scan', user
          }.to change{ Event.count }.by(1)
        end
      end

      context "if the event exists" do
        it "does not create a new event" do
          user = build :user
          create :event, :scan, user: user
          expect {
            Event.log 'scan', user
          }.to change{ Event.count }.by(0)
        end
      end
    end

    context "when current user is admin" do
      it "does not create a new event" do
        admin = build :admin
        expect {
          Event.log 'scan', admin
        }.to change{ Event.count }.by(0)
      end
    end
  end
end
