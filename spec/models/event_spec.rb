require 'spec_helper'
include Devise::TestHelpers

describe Event do
  it "has a valid factory" do
    build(:event).should be_valid
  end

  it "validates presence of event_type" do
    build(:event, event_type: nil).should_not be_valid
  end

  it "validates event_type is a known type" do
    build(:event, event_type: 'unknown').should_not be_valid
  end

  describe "log" do
    context "if the event does not exists" do
      it "creates a new event" do
        user = build :user
        expect {
          Event.log 'registration', user
        }.to change{ Event.count }.by(1)
      end
    end

    context "if the event exists" do
      it "does not create a new event" do
        user = build :user
        create :event, :registration, user: user
        expect {
          Event.log 'registration', user
        }.to change{ Event.count }.by(0)
      end
    end
  end

  describe "log_without_user" do
    it "creates a new event" do
      expect {
        Event.log_without_user 'landing', '200.10.20.30', 'agent'
      }.to change{ Event.count }.by(1)
    end

    it "avoids Googlebot agent" do
      expect {
        Event.log_without_user 'landing', '200.10.20.30', 'Googlebot'
      }.to change{ Event.count }.by(0)
    end

    it "avoids duplicate ip" do
      expect {
        Event.log_without_user 'landing', '200.10.20.30', 'agent'
        Event.log_without_user 'landing', '200.10.20.30', 'agent'
      }.to change{ Event.count }.by(1)
    end
  end
end
