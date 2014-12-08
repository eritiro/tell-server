require 'spec_helper'

describe FeedsController do
  context "admin" do
    before { sign_in create(:admin) }
    describe "GET index" do
      it "assigns all feeds as @feeds" do
        feed = create(:feed)
        get :index
        assigns(:feeds).should eq([feed])
      end

      describe ".json" do
        render_views
        include ApplicationHelper
        let(:json) { JSON.parse(response.body) }

        it "returns array of feeds" do
          feed = create(:feed)
          get :index, format: :json
          json.first['title'].should eq feed.title
          json.first['detail'].should eq feed.detail
          json.first['action'].should eq feed.action
          json.first['type'].should eq feed.type
        end

        it "returns feed users" do
          user = create(:user)
          feed = create(:feed, users: [user])
          get :index, format: :json
          user_json = json.first['users'].first
          user_json['id'].should eq user.id
          user_json['icon'].should eq absolute_url(user.picture(:icon))
        end
      end
    end

    describe "GET show" do
      it "assigns the requested feed as @feed" do
        feed = create(:feed)
        get :show, {:id => feed.to_param}
        assigns(:feed).should eq(feed)
      end
    end

    describe "GET new" do
      it "assigns a new feed as @feed" do
        get :new, {}
        assigns(:feed).should be_a_new(Feed)
      end
    end

    describe "GET edit" do
      it "assigns the requested feed as @feed" do
        feed = create(:feed)
        get :edit, {:id => feed.to_param}
        assigns(:feed).should eq(feed)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Feed" do
          expect {
            post :create, {:feed => attributes_for(:feed)}
          }.to change(Feed, :count).by(1)
        end

        it "assigns a newly created feed as @feed" do
          post :create, {:feed => attributes_for(:feed)}
          assigns(:feed).should be_a(Feed)
          assigns(:feed).should be_persisted
        end

        it "redirects to the created feed" do
          post :create, {:feed => attributes_for(:feed)}
          response.should redirect_to(Feed.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved feed as @feed" do
          # Trigger the behavior that occurs when invalid params are submitted
          Feed.any_instance.stub(:save).and_return(false)
          post :create, {:feed => { "title" => "invalid value" }}
          assigns(:feed).should be_a_new(Feed)
        end

        it "re-renders the 'new' template" do
          post :create, {:feed => { "type" => "" }}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested feed" do
          feed = create(:feed)
          # Assuming there are no other feeds in the database, this
          # specifies that the Feed created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Feed.any_instance.should_receive(:update).with({ "title" => "MyString" })
          put :update, {:id => feed.to_param, :feed => { "title" => "MyString" }}
        end

        it "assigns the requested feed as @feed" do
          feed = create(:feed)
          put :update, {:id => feed.to_param, :feed => attributes_for(:feed)}
          assigns(:feed).should eq(feed)
        end

        it "redirects to the feed" do
          feed = create(:feed)
          put :update, {:id => feed.to_param, :feed => attributes_for(:feed)}
          response.should redirect_to(feed)
        end
      end

      describe "with invalid params" do
        it "assigns the feed as @feed" do
          feed = create(:feed)
          # Trigger the behavior that occurs when invalid params are submitted
          Feed.any_instance.stub(:save).and_return(false)
          put :update, {:id => feed.to_param, :feed => { "title" => "invalid value" }}
          assigns(:feed).should eq(feed)
        end

        it "re-renders the 'edit' template" do
          feed = create(:feed)
          put :update, {:id => feed.to_param, :feed => { "type" => "" }}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested feed" do
        feed = create(:feed)
        expect {
          delete :destroy, {:id => feed.to_param}
        }.to change(Feed, :count).by(-1)
      end

      it "redirects to the feeds list" do
        feed = create(:feed)
        delete :destroy, {:id => feed.to_param}
        response.should redirect_to(feeds_url)
      end
    end
  end
end
