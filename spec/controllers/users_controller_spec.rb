require 'spec_helper'

describe UsersController do

  before { sign_in create(:user) }

  describe "GET index" do
    it "assigns all users as @users" do
      user = create :user
      get :index, {}
      assigns(:users).should include(user)
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = create :user
      get :show, {:id => user.to_param}
      assigns(:user).should eq(user)
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