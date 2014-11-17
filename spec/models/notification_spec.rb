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

  describe "unread" do
    it "includes unread notifications" do
      notification = create(:notification, read: false)
      Notification.unread.should include(notification)
    end

    it "does not includes read notifications" do
      notification = create(:notification, read: true)
      Notification.unread.should_not include(notification)
    end
  end
end
