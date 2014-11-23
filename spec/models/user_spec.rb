require 'spec_helper'

describe User do
  it "has a valid factory" do
    build(:user).should be_valid
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

  describe "notify" do
    describe "model" do
      let(:user) { create(:user) }
      let(:sender) { create(:user) }
      let(:attributes) { { from: sender, text: "Hello", title: "Title", type: "message" } }

      it "creates a new notification" do
        expect{
          user.notify(attributes)
        }.to change{ Notification.count }.by(1)
      end

      it "removes notifications from the same user and type" do
        old_notification = create(:notification, from: sender, to: user, type: "message")
        expect{
          user.notify(attributes)
        }.to change{ Notification.count }.by(0)
        Notification.find_by_id(old_notification).should be_nil
      end

      it "does not remove notifications from other users" do
        old_notification = create(:notification, to: user, type: "message")
        expect{
          user.notify(attributes)
        }.to change{ Notification.count }.by(1)
      end

      it "does not remove notifications of other types" do
        old_notification = create(:notification, from: sender, to: user, type: "invite")
        expect{
          user.notify(attributes)
        }.to change{ Notification.count }.by(1)
      end
    end

    it "pushes a notification to the device" do
      user = create(:user, device_token: "valid_token")
      sender = create(:user)
      GCM.should_receive(:send_notification)
      user.notify(from: sender, text: "Hello", title: "Title", type: "message")
    end

    it "does not push a read notification" do
      user = create(:user, device_token: "valid_token")
      sender = create(:user)
      GCM.should_not_receive(:send_notification)
      user.notify(from: sender, text: "Hello", title: "Title", type: "message", read: true)
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
