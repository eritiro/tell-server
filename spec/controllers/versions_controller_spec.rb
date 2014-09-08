require 'spec_helper'

describe VersionsController do

  before { sign_in create(:admin) }

  describe "GET index" do
    it "assigns all versions as @versions" do
      version = create(:version)
      get :index, {}
      assigns(:versions).should eq([version])
    end
  end

  describe "GET show" do
    it "assigns the requested version as @version" do
      version = create(:version)
      get :show, {:id => version.to_param}
      assigns(:version).should eq(version)
    end
  end

  describe "GET new" do
    it "assigns a new version as @version" do
      get :new, {}
      assigns(:version).should be_a_new(Version)
    end
  end

  describe "GET edit" do
    it "assigns the requested version as @version" do
      version = create(:version)
      get :edit, {:id => version.to_param}
      assigns(:version).should eq(version)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Version" do
        expect {
          post :create, {:version => attributes_for(:version)}
        }.to change(Version, :count).by(1)
      end

      it "assigns a newly created version as @version" do
        post :create, {:version => attributes_for(:version)}
        assigns(:version).should be_a(Version)
        assigns(:version).should be_persisted
      end

      it "redirects to the created version" do
        post :create, {:version => attributes_for(:version)}
        response.should redirect_to(Version.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved version as @version" do
        # Trigger the behavior that occurs when invalid params are submitted
        Version.any_instance.stub(:save).and_return(false)
        post :create, {:version => { "name" => "invalid value" }}
        assigns(:version).should be_a_new(Version)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Version.any_instance.stub(:save).and_return(false)
        post :create, {:version => { "name" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested version" do
        version = create(:version)
        # Assuming there are no other versions in the database, this
        # specifies that the Version created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Version.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => version.to_param, :version => { "name" => "MyString" }}
      end

      it "assigns the requested version as @version" do
        version = create(:version)
        put :update, {:id => version.to_param, :version => attributes_for(:version)}
        assigns(:version).should eq(version)
      end

      it "redirects to the version" do
        version = create(:version)
        put :update, {:id => version.to_param, :version => attributes_for(:version)}
        response.should redirect_to(version)
      end
    end

    describe "with invalid params" do
      it "assigns the version as @version" do
        version = create(:version)
        # Trigger the behavior that occurs when invalid params are submitted
        Version.any_instance.stub(:save).and_return(false)
        put :update, {:id => version.to_param, :version => { "name" => "invalid value" }}
        assigns(:version).should eq(version)
      end

      it "re-renders the 'edit' template" do
        version = create(:version)
        # Trigger the behavior that occurs when invalid params are submitted
        Version.any_instance.stub(:save).and_return(false)
        put :update, {:id => version.to_param, :version => { "name" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested version" do
      version = create(:version)
      expect {
        delete :destroy, {:id => version.to_param}
      }.to change(Version, :count).by(-1)
    end

    it "redirects to the versions list" do
      version = create(:version)
      delete :destroy, {:id => version.to_param}
      response.should redirect_to(versions_url)
    end
  end

end
