require 'spec_helper'

describe Message do
  it "has a valid factory" do
    build(:message).should be_valid
  end

  it "requires from" do
    build(:message, from: nil).should_not be_valid
  end

  it "requires to" do
    build(:message, to: nil).should_not be_valid
  end
end
