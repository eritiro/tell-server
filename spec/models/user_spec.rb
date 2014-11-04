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

  describe "gender" do
    it "should be male or female" do
      build(:user, gender: 'male').should be_valid
      build(:user, gender: 'female').should be_valid
      build(:user, gender: 'other').should_not be_valid
    end
  end

  describe "on destroy" do
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
