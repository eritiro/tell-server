require 'spec_helper'

describe LocationsController do
  before { sign_in create(:user) }

  describe "GET index" do
    it "assigns all locations as @locations" do
      location = create(:location)
      get :index, {}
      assigns(:locations).should eq([location])
    end

    context "with req" do
      context "of an existing location" do
        before do
          @location = create(:location, afip_req: "e1ttZXRob2Q9Z2V0UHVibGljSW5mb11bcGVyc29uYT0zMDY0MjU0MDUwMV1bdGlwb2RvbWljaWxpbz0xXVtzZWN1ZW5jaWE9MV19")
          get :index, { req: @location.afip_req, format: :json }
        end

        it { assigns(:location).should eq(@location) }
        it { response.should render_template("show") }
      end

      context "of an unexisting location" do
        before do
          LocationsHelper.should_receive(:get_location).with("abcde").and_return(build(:location, afip_req: "abcde"))
        end

        it "creates a location" do
          expect{ get(:index, { req: "abcde", format: :json }) }.to change{Location.count}.by(1)
        end

        context do
          before do
            get :index, { req: "abcde", format: :json }
          end

          it "assigns the req to afip_req" do
            Location.last.afip_req.should == "abcde"
          end

          it { assigns(:location).should be_a(Location) }
          it { response.should render_template("show") }
        end
      end 
    end
  end

  describe "GET show" do
    it "assigns the requested location as @location" do
      location = create(:location)
      get :show, {:id => location.to_param}
      assigns(:location).should eq(location)
    end
  end

  describe "GET new" do
    it "assigns a new location as @location" do
      get :new, {}
      assigns(:location).should be_a_new(Location)
    end
  end

  describe "GET edit" do
    it "assigns the requested location as @location" do
      location = create(:location)
      get :edit, {:id => location.to_param}
      assigns(:location).should eq(location)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Location" do
        expect {
          post :create, {:location => attributes_for(:location)}
        }.to change(Location, :count).by(1)
      end

      it "assigns a newly created location as @location" do
        post :create, {:location => attributes_for(:location)}
        assigns(:location).should be_a(Location)
        assigns(:location).should be_persisted
      end

      it "redirects to the created location" do
        post :create, {:location => attributes_for(:location)}
        response.should redirect_to(Location.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved location as @location" do
        # Trigger the behavior that occurs when invalid params are submitted
        Location.any_instance.stub(:save).and_return(false)
        post :create, {:location => { "name" => "invalid value" }}
        assigns(:location).should be_a_new(Location)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Location.any_instance.stub(:save).and_return(false)
        post :create, {:location => { "name" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested location" do
        location = create(:location)
        # Assuming there are no other locations in the database, this
        # specifies that the Location created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Location.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => location.to_param, :location => { "name" => "MyString" }}
      end

      it "assigns the requested location as @location" do
        location = create(:location)
        put :update, {:id => location.to_param, :location => attributes_for(:location)}
        assigns(:location).should eq(location)
      end

      it "redirects to the location" do
        location = create(:location)
        put :update, {:id => location.to_param, :location => attributes_for(:location)}
        response.should redirect_to(location)
      end
    end

    describe "with invalid params" do
      it "assigns the location as @location" do
        location = create(:location)
        # Trigger the behavior that occurs when invalid params are submitted
        Location.any_instance.stub(:save).and_return(false)
        put :update, {:id => location.to_param, :location => { "name" => "invalid value" }}
        assigns(:location).should eq(location)
      end

      it "re-renders the 'edit' template" do
        location = create(:location)
        # Trigger the behavior that occurs when invalid params are submitted
        Location.any_instance.stub(:save).and_return(false)
        put :update, {:id => location.to_param, :location => { "name" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested location" do
      location = create(:location)
      expect {
        delete :destroy, {:id => location.to_param}
      }.to change(Location, :count).by(-1)
    end

    it "redirects to the locations list" do
      location = create(:location)
      delete :destroy, {:id => location.to_param}
      response.should redirect_to(locations_url)
    end
  end

end
