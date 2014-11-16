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

        create_list :event, 4, :landing
        create_list :event, 3, :registration
        create_list :event, 2, :attend
        create_list :event, 1, :chat

        get :index, {}
        assigns(:events).map{|event| event[:values] }.should eq [[100], [75], [50], [25]]
      end
    end
  end
end