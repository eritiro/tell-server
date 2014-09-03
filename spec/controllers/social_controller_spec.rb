require 'spec_helper'

describe SocialController do
  describe "POST facebook" do
    context "with valid credentials" do
      before do
        @me = {
          "id" => "10152363454658285",
          "email" => "pomelo@gmail.com",
          "name" => "pomelo"
        }
        Koala::Facebook::API.any_instance.should_receive(:get_object).with("me").and_return(@me)
      end

      it "returns success" do
        post :facebook, {format: :json, token: "abc"}
        response.status.should eq 200
      end

      it "assigns user" do
        post :facebook, {format: :json, token: "abc"}
        assigns(:user).should be_a(User)
      end
    end

    context "with invalid credentials" do
      before do
        Koala::Facebook::API.any_instance.stub(:get_object){ raise Koala::Facebook::AuthenticationError.new(401, "Authentication failed") }
      end

      it "returns unauthorized" do
        post :facebook, {format: :json, token: "abc"}
        response.status.should eq 401
      end

    end
  end

  describe "find_or_create_user" do
    before do
      @me = {
        "id" => "10152363454658285",
        "email" => "pomelo@gmail.com",
        "name" => "pomelo"
      }
    end

    context "without existing user" do
      it "creates a new user user" do
        expect { subject.send(:find_or_create_user, @me) }.to change(User, :count).by(1)
      end

      it "returns a new user with email and stuff" do
        user = subject.send(:find_or_create_user, @me)
        user.email.should eq(@me['email'])
        user.guessed_username.should eq(@me['name'])
        user.identities.first.uid.should eq(@me['id'])
        user.identities.first.provider.should eq('facebook')
      end

      context "without email" do
        before do
          @me = {
            "id" => "10152363454658285",
            "name" => "pomelo"
          }
        end

        it "returns a new user with email and stuff" do
          user = subject.send(:find_or_create_user, @me)
          user.email.should be_present
          user.guessed_username.should eq(@me['name'])
          user.identities.first.uid.should eq(@me['id'])
          user.identities.first.provider.should eq('facebook')
        end
      end
    end

    context "with existing user" do
      before do
        @user = create :user, email: "pomelo@gmail.com"
      end

      it "adds an identity to the user" do
        subject.send(:find_or_create_user, @me)
        @user.reload.identities.first.uid.should eq(@me['id'])
      end

      context "and existing identity" do
        before do
          create :identity, user: @user, provider: 'facebook', uid: @me['id']
        end

        it { expect { subject.send(:find_or_create_user, @me) }.to change(Identity, :count).by(0) }

        it "returns the user" do
          subject.send(:find_or_create_user, @me).should eq @user
        end
      end
    end
  end
end