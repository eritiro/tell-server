require 'spec_helper'

describe "versions/index" do
  before(:each) do
    @versions = build_list(:version, 2, id: 1, created_at: Time.now)
    @versions.first.stub(:number_of_users).and_return(20)
    @versions.first.stub(:days_online).and_return(14)
    assign(:versions, @versions)
  end

  it "renders a list of versions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @versions.first.name, :count => 2
    assert_select "tr>td", :text => @versions.first.created_at, :count => 2
    assert_select "tr>td", :text => @versions.first.number_of_users, :count => 1
    assert_select "tr>td", :text => @versions.first.days_online, :count => 1
  end
end
