require 'spec_helper'

describe User do
  it "has a valid factory" do
    build(:user).should be_valid
  end

  it "validates unique username" do
    create(:user, username: "pepe")
    build(:user, username: "Pepe").should_not be_valid
  end

  describe "authentication_token" do
    it "is generated after save" do
      user = build(:user)
      user.save!
      user.authentication_token.should be_present
    end
  end
end
