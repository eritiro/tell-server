require 'spec_helper'

describe Location do
  it "has a valid factory" do
    build(:location).should be_valid
  end

  it "should have many attendees inverse of location" do
    location = build(:location)
    user = build(:user)
    location.attendees << user
    user.location.should eq location
  end

  describe ".to_s" do
    it "returns the name" do
      build(:location, name: "test").to_s.should eq "test"
    end
  end
end
