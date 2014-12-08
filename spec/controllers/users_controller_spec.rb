require 'spec_helper'

describe UsersController do

  before { sign_in create(:admin) }

  describe "GET index" do
    it "assigns all users as @users" do
      user = create :user
      get :index, {}
      assigns(:users).should include(user)
    end

    it "assigns all versions as @versions" do
      version = create :version
      get :index, {}
      assigns(:versions).should include(version)
    end

    context "with version_id" do
      it "includes user created after version" do
        version = create :version
        user = create :user
        create(:event, :registration, user: user)
        get :index, { version_id: version.id }
        assigns(:users).should include(user)
      end

      it "does not includes user created before version" do
        user = create :user
        create(:event, :registration, user: user)
        Timecop.travel(1.minute.from_now)
        version = create :version
        get :index, { version_id: version.id }
        assigns(:users).should_not include(user)
      end
    end

    context "with Export commit" do
      it "exports an xlsx file" do
        user = create :user
        get :index, { commit: 'Export' }
        response.headers["Content-Type"].should eq "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      end
    end
  end

  describe "GET show" do
    let(:current_user){ create :user }
    let(:user) { create :user }

    before { sign_in current_user }

    it "assigns the requested user as @user" do
      get :show, {:id => user.to_param}
      assigns(:user).should eq(user)
    end

    it "marks notification as read" do
      notification = create(:notification, to: current_user, from: user, type: 'invite')
      get :show, {:id => user.to_param}
      notification.reload.read.should be_true
    end

    describe ".json" do
      render_views
      include ApplicationHelper
      let(:json) { JSON.parse(response.body) }

      it "returns the user info" do
        get :show, id: user.to_param, format: :json
        json["picture"].should eq absolute_url(user.picture.url(:medium))
        json["gender"].should eq user.gender
      end

      it "returns they location" do
        location = create(:location)
        user = create(:user, location: location)
        get :show, id: user.to_param, format: :json
        json["location"]["id"].should eq location.id
        json["location"]["name"].should eq location.name
      end

      context "without invitation" do
        it "returns that the user was not invited" do
          get :show, id: user.to_param, format: :json
          json["was_invited"].should be_false
        end

        it "returns that the user was not invited even if they chat" do
          create :notification, from: current_user, to: user, type: 'message'
          get :show, id: user.to_param, format: :json
          json["was_invited"].should be_false
        end
      end

      context "with invitation" do
        it "returns that the user was invited" do
          create :notification, from: current_user, to: user, type: 'invite'
          get :show, id: user.to_param, format: :json
          json["was_invited"].should be_true
        end
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      user = create :user
      get :edit, {:id => user.to_param}
      assigns(:user).should eq(user)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user" do
        user = create :user
        # Assuming there are no other users in the database, this
        # specifies that the User created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        User.any_instance.should_receive(:update).with({ "username" => "MyString" })
        put :update, {:id => user.to_param, :user => { "username" => "MyString" }}
      end

      it "assigns the requested user as @user" do
        user = create :user
        put :update, {:id => user.to_param, :user => attributes_for(:user)}
        assigns(:user).should eq(user)
      end

      it "redirects to the user" do
        user = create :user
        put :update, {:id => user.to_param, :user => attributes_for(:user)}
        response.should redirect_to(user)
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        user = create :user
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => user.to_param, :user => { "username" => "invalid value" }}
        assigns(:user).should eq(user)
      end

      it "re-renders the 'edit' template" do
        user = create :user
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => user.to_param, :user => { "username" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      user = create :user
      expect {
        delete :destroy, {:id => user.to_param}
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = create :user
      delete :destroy, {:id => user.to_param}
      response.should redirect_to(users_url)
    end
  end

  describe "POST invite" do
    before { sign_in create(:user) }

    it "notifies user" do
      user = create :user
      User.any_instance.should_receive(:notify)
      post :invite, id: user.to_param
    end
  end

  describe "GET profile" do
    let(:user) { create(:user) }
    before { sign_in user }

    describe ".json" do
      render_views
      include ApplicationHelper
      let(:json) { JSON.parse(response.body) }

      it "returns the number of unread notifications" do
        get :profile, format: :json
        json["unread_notifications"].should eq 0
      end

      it "returns the attending location id" do
        attending_location = create(:location)
        user.update(location_id: attending_location.id)
        get :profile, format: :json
        json["attending_location_id"].should eq attending_location.id
      end

      it "returns the location" do
        location = create(:location)
        user.update(location_id: location.id)
        get :profile, format: :json
        json["location"]["id"].should eq location.id
      end

      it "returns notifications" do
        notification = create :notification, to: user
        get :profile, format: :json
        json["notifications"].first["id"].should eq notification.id
      end

      it "returns feeds" do
        feed = create :feed
        get :profile, format: :json
        json["feeds"].first["id"].should eq feed.id
      end
    end
  end

  describe "PUT leave" do
    it "reset the attending status of all users" do
      location = create(:location)
      user = create(:user, location: location)
      put :leave
      user.reload.location.should be_nil
    end

    it "should redirect to index" do
      put :leave
      response.should redirect_to(users_path)
    end
  end

  describe "POST alert" do
    it "sends a push notification to each user" do
      GCM.should_receive(:send_notification).once
      user = create(:user, device_token: 'any_token')
      post :alert
    end

    it "does not create a notification" do
      user = create(:user, device_token: 'any_token')
      expect{ post :alert }.to change(Notification, :count).by(0)
    end

    it "avoids users that ara attending a location" do
      GCM.should_receive(:send_notification).never
      location = create(:location)
      user = create(:user, device_token: 'any_token', location: location)
      post :alert
    end

    it "avoids users without device_token" do
      GCM.should_receive(:send_notification).never
      location = create(:location)
      user = create(:user)
      post :alert
    end

    it "should redirect to index" do
      post :alert
      response.should redirect_to(users_path)
    end
  end
end
