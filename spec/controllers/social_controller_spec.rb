require 'spec_helper'

describe SocialController do
  describe "PUT facebook" do
    context "with valid credentials" do
      before do
        @me = {
          "id" => "10152363454658285",
          "email" => "pomelo@gmail.com",
          "name" => "pomelo",
          "gender" => "male",
          "birthday" => "08/04/1985"
        }
        @photos = [
          { "source" => "http://example.url.com/1.jpg" },
          { "source" => "http://example.url.com/2.jpg" }
        ]

        @batch_api = Object.new
        Koala::Facebook::API.any_instance.should_receive(:batch).and_return([@me, @photos])
      end

      it "returns success" do
        put :facebook, {format: :json, token: "abc"}
        response.status.should eq 200
      end

      it "assigns user" do
        put :facebook, {format: :json, token: "abc"}
        assigns(:user).should be_a(User)
      end
    end

    context "with invalid credentials" do
      before do
        Koala::Facebook::API.any_instance.stub(:get_object){ raise Koala::Facebook::AuthenticationError.new(401, "Authentication failed") }
      end

      it "returns unauthorized" do
        put :facebook, {format: :json, token: "abc"}
        response.status.should eq 401
      end

    end
  end

  describe "PUT photo_select" do
    context "with valid id" do
      before do
        @user = create :user
      end

      it "returns no content" do
        put :photo_select, { id: @user.id, photos: [ "a", "b" ] }
        response.status.should eq 204
      end

      it "sets photos" do
        put :photo_select, { id: @user.id, photos: [ "a", "b" ] }
        @user.reload
        @user.user_photos.should have(2).items
      end
    end
  end

  describe "find_or_create_user" do
    before do
      @me = {
        "id" => "10152363454658285",
        "email" => "pomelo@gmail.com",
        "name" => "pomelo",
        "gender" => "male",
        "birthday" => "08/04/1985"
      }
    end

    context "without existing user" do
      it "creates a new user" do
        expect { subject.send(:find_or_create_user, @me) }.to change(User, :count).by(1)
      end

      it "creates a new registration event" do
        expect { subject.send(:find_or_create_user, @me) }.to change(Event, :count).by(1)
        Event.last.event_type.should eq('registration')
      end

      it "returns a new user with email and stuff" do
        user = subject.send(:find_or_create_user, @me)
        user.email.should eq(@me['email'])
        user.username.should eq(@me['name'])
        user.identities.first.uid.should eq(@me['id'])
        user.identities.first.provider.should eq('facebook')
      end

      context "without email" do
        before do
          @me = {
            "id" => "10152363454658285",
            "name" => "pomelo",
            "gender" => "male",
            "birthday" => "08/04/1985"
          }
        end

        it "returns a new user with email and stuff" do
          user = subject.send(:find_or_create_user, @me)
          user.email.should be_present
          user.username.should eq(@me['name'])
          user.gender.should eq('male')
          user.birthday.should eq Date.new(1985, 8, 4)

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

      it "does not create a new event" do
        expect { subject.send(:find_or_create_user, @me) }.to change(Event, :count).by(0)
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
