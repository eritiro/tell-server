require 'spec_helper'
include Devise::TestHelpers

describe NavigationHelper do
  describe "menu_items" do
    before do
      Object.any_instance.stub(:user_signed_in?).and_return true
      Object.any_instance.stub(:can?).and_return true
      params[:controller] = "metrics"
    end

    it "contains an array which first item is locations" do
      menu_items.first[:text].should eq "Metrics"
      menu_items.first[:path].should eq "/metrics"
    end

    context "on MetricsController" do
      it "mark MetricsController as current" do
        menu_items.first[:current].should be_true
      end
    end

    context "on LocationsController" do
      it "does not mark MetricsController as current" do
        params[:controller] = "LocationsController"
        menu_items.first[:current].should be_false
      end
    end
  end
end
