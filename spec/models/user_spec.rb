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

  describe "find_for_oauth" do
    before do
      info = double("info", email: "pomelo@gmail.com", verified: true)
      raw_info = double("raw_info", name: "pomelo")
      extra = double("extra", raw_info: raw_info)
      @oauth = double("oauth", uid: "10152363454658285", provider: 'facebook', info: info, extra: extra)
    end

    context "without existing user" do
      it "creates a new user user" do
        expect { User.find_for_oauth(@oauth) }.to change(User, :count).by(1)
      end

      it "returns a new user with email and stuff" do
        user = User.find_for_oauth(@oauth)
        user.email.should eq(@oauth.info.email)
        user.guessed_username.should eq(@oauth.extra.raw_info.name)
        user.identities.first.uid.should eq(@oauth.uid)
        user.identities.first.provider.should eq(@oauth.provider)
      end
    end

    context "with existing user" do
      before do
        @user = create :user, email: "pomelo@gmail.com"
      end

      it "adds an identity to the user" do
        User.find_for_oauth(@oauth)
        @user.reload.identities.first.uid.should eq(@oauth.uid)
      end

      context "and existing identity" do
        before do
          create :identity, user: @user, provider: @oauth.provider, uid: @oauth.uid
        end

        it { expect { User.find_for_oauth(@oauth) }.to change(Identity, :count).by(0) }

        it "returns the user" do
          User.find_for_oauth(@oauth).should eq @user
        end
      end
    end
  end
end
