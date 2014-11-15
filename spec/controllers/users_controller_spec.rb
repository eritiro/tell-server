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
    it "assigns the requested user as @user" do
      user = create :user
      get :show, {:id => user.to_param}
      assigns(:user).should eq(user)
    end

    describe ".json" do
      render_views
      include ApplicationHelper
      let(:json) { JSON.parse(response.body) }

      it "returns the user image" do
        user = create :user
        get :show, id: user.to_param, format: :json
        json["picture"].should eq absolute_url(user.picture.url(:original))
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

end
