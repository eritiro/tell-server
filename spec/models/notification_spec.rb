require 'spec_helper'

describe Notification do
  it "has a valid factory" do
    build(:notification).should be_valid
  end

  it "requires from" do
    build(:notification, from: nil).should_not be_valid
  end

  it "requires to" do
    build(:notification, to: nil).should_not be_valid
  end
end
