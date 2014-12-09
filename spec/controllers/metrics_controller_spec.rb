require 'spec_helper'

describe MetricsController do
  before { sign_in create(:admin) }

  describe "GET index" do
    it "assigns all versions as @versions" do
      create :version
      get :index, {}
      assigns(:versions).should eq Version.all
    end

    it "has one row per event_type" do
      get :index, {}
      assigns(:events).map{|event| event[:key] }.should eq Event::TYPES
    end

    describe "with landing data" do
      it "counts TYPES" do
        create :version

        create_list :event, 8, :landing
        create_list :event, 6, :registration
        create_list :event, 3, :attend

        get :index, {}
        assigns(:events).map{|event| event[:values] }.should eq [
          [{accumulated: 100, compared: nil}],
          [{accumulated: 75, compared: 25}],
          [{accumulated: 37, compared: 50}],
          [{accumulated: 0, compared: 100}]]
      end
    end
  end
end