require 'spec_helper'

describe RegistrationsController do

  let(:user) { create :user }
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe "POST create" do
    it "logs the event" do
      Event.should_receive(:log).with("registration", an_instance_of(User))
      post :create, { :user => attributes_for(:user) }
    end
  end

  describe "PUT update" do
    describe "normal login" do
      before { sign_in user }
      describe "with valid params" do
        it "updates the requested user" do
          User.any_instance.should_receive(:update_without_password).with({ 'username' => 'suelopoder', 'completed_tutorial' => 'true' })
          put :update, { :user => { username: "suelopoder", completed_tutorial: "true" } }
        end

        describe "changing the password" do
          it "updates the requested user" do
            User.any_instance.should_receive(:update_with_password).with({ 'username' => 'suelopoder', 'current_password' => '1234' })
            put :update, { :user => { username: "suelopoder", current_password: "1234" } }
          end
        end

        it "does not mess up with events" do
          Event.should_not_receive(:log)
          put :update, { :user => attributes_for(:user) }
        end

        it "assigns the requested user as @user" do
          put :update, { :user => attributes_for(:user) }
          assigns(:user).should eq(user)
        end

        it "redirects to the user" do
          put :update, { :user => attributes_for(:user) }
          response.should redirect_to(subject.send(:after_update_path_for,user))
        end
      end

      describe "with invalid params" do
        it "assigns the user as @user" do
          User.any_instance.stub(:update_without_password).and_return(false)
          put :update, {:user => { "username" => "invalid value" }}
          assigns(:user).should eq(user)
        end

        it "re-renders the 'edit' template" do
          User.any_instance.stub(:update_without_password).and_return(false)
          put :update, {:user => { "username" => "invalid value" }}
          response.should redirect_to(user_path(user))
        end
      end
    end
    describe "header login" do
      before do
        subject.request.headers["User-Id"] = user.id
        subject.request.headers["User-Token"] = user.authentication_token
      end

      it "updates the requested user" do
        User.any_instance.should_receive(:update_without_password).with({ "username" => "MyString" })
        put :update, { :user => { "username" => "MyString" }, format: :json }
      end

      it "actually works" do
        put :update, { :user => { "username" => "cool" }, format: :json }
        user.reload.username.should eq("cool")
      end

      it "returns no content" do
        put :update, { :user => attributes_for(:user), format: :json }
        expect(response.response_code).to eq(204)
      end
    end
  end
end
