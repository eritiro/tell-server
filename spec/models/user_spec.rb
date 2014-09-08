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

  describe "on destroy" do
    it "destroy they comments" do
      user = create(:user)
      create(:comment, author: user)
      expect {
        user.destroy
      }.to change(Comment, :count).by(-1)
    end

    it "destroy they events" do
      user = create(:user)
      create(:event, user: user)
      expect {
        user.destroy
      }.to change(Event, :count).by(-1)
    end

    it "destroy they identities" do
      user = create(:user)
      create(:identity, user: user)
      expect {
        user.destroy
      }.to change(Identity, :count).by(-1)
    end
  end
end
