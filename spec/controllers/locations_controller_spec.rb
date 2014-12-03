require 'spec_helper'

describe LocationsController do
  context "admin" do
    before { sign_in create(:admin) }

    describe "GET index" do
      it "assigns all locations as @locations" do
        location = create(:location)
        get :index, {}
        assigns(:locations).should eq([location])
      end

      it "includes 'this' when searching for 'th'" do
        this_location = create(:location, name: 'this')
        get :index, { name: 'th' }
        assigns(:locations).should include(this_location)
      end

      it "excludes 'this' when searching for 'that'" do
        this_location = create(:location, name: 'this')
        get :index, { name: 'that' }
        assigns(:locations).should_not include(this_location)
      end

      it "finds by alternative name" do
        location = create(:location, alternative_name: 'araos')
        get :index, { name: 'ara' }
        assigns(:locations).should include(location)
      end

      describe "secondary search" do
        it "finds by description name" do
          location = create(:location, description: 'ubicado en palermo')
          get :index, { name: 'palermo' }
          assigns(:locations).should include(location)
        end

        it "finds by address" do
          location = create(:location, address: 'Santa Fe 123, palermo')
          get :index, { name: 'palermo' }
          assigns(:locations).should include(location)
        end

        it "puts matching names first" do
          more_relevant = create(:location, name: 'palermo')
          less_relevant = create(:location, description: 'ubicado en palermo')
          get :index, { name: 'palermo' }
          assigns(:locations).should eq([more_relevant, less_relevant])
        end

        it "avoids duplicates" do
          location = create(:location, name: 'palermo', description: 'ubicado en palermo')
          get :index, { name: 'palermo' }
          assigns(:locations).should eq [location]
        end
      end

      it "orders by relevance" do
        non_relevant = create(:location, relevance: 0)
        relevant = create(:location, relevance: 1000)

        get :index
        assigns(:locations).should eq([relevant, non_relevant])
      end

      describe '.json' do
        render_views
        include ApplicationHelper
        let(:json) { JSON.parse(response.body) }

        it "renders json" do
          location = create(:location)
          get :index, format: "json"
          json.first["name"].should eq location.name
          json.first["address"].should eq location.address
          json.first["phone"].should eq location.phone
          json.first["photo"].should eq absolute_url(location.photo.url(:thumb))
        end
      end
    end

    describe "GET show" do
      it "assigns the requested location as @location" do
        location = create(:location)
        get :show, {:id => location.to_param}
        assigns(:location).should eq(location)
      end

      describe '.json' do
        render_views
        include ApplicationHelper
        let(:json) { JSON.parse(response.body) }

        it "renders json" do
          location = create(:location)
          get :show, {:id => location.to_param, format: "json"}
          json["name"].should eq location.name
          json["address"].should eq location.address
          json["capacity"].should eq location.capacity
          json["photo"].should eq ("http://test.com" + location.photo.url(:medium))
          json["description"].should eq location.description
          json["attendees"].should eq location.attendees.count
        end
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
end
