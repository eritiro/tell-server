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


      describe '.json' do
        render_views

        it "renders json" do
          location = create(:location)
          get :index, format: "json"
          response.body.should include(location.name)
          response.body.should include(location.address)
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

        it "renders json" do
          location = create(:location)
          comment = create(:comment, location: location)
          get :show, {:id => location.to_param, format: "json"}
          response.body.should include(location.name)
          response.body.should include(location.address)
          response.body.should include("test.com" + location.photo.url(:medium))
          response.body.should include(comment.text)
          response.body.should include(comment.author.username)
          response.body.should include(comment.author.picture.url(:thumb))
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

  context "with regular user" do
    let(:current_user){ create(:user) }
    before { sign_in current_user }

    describe "POST scan" do
      it "logs a scan" do
        @location = create :location
        Event.should_receive(:log).with("scan", current_user)
        post :scan, { url: @location.afip_url, format: :json }
      end

      context "of an existing location" do
        before do
          LocationCrawler.any_instance.should_not_receive(:get_location)
          @location = create :location
          post :scan, { url: @location.afip_url, format: :json }
        end

        it { assigns(:location).should eq(@location) }
        it { response.should render_template("show") }

        it "does not create a location" do
          expect{ post(:scan, { url: @location.afip_url, format: :json }) }.to change{ Location.count }.by(0)
        end
      end

      context "of an invalid URL" do
        before do
          @scan_url = "abcde"
          LocationCrawler.any_instance.should_receive(:get_location).and_raise(LocationCrawler::LocationCrawlerError)
          post :scan, { url: @scan_url, format: :json }
        end

        it { response.status.should eq 422 }
        it { JSON.parse(response.body)["url"].should eq @scan_url }
      end

      context "of an unexisting location" do
        before do
          LocationCrawler.any_instance.should_receive(:get_location).with("abcde").and_return(build(:location, afip_url: "abcde"))
        end

        it "creates a location" do
          expect{ post(:scan, { url: "abcde", format: :json }) }.to change{Location.count}.by(1)
        end

        context do
          before do
            post :scan, { url: "abcde", format: :json }
          end

          it "assigns the url to afip_url" do
            Location.last.afip_url.should == "abcde"
          end

          it { assigns(:location).should be_a(Location) }
          it { response.should render_template("show") }
        end
      end
    end
  end
end
