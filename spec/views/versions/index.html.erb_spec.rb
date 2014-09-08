require 'spec_helper'

describe "versions/index" do
  before(:each) do
    @versions = build_list(:version, 2, id: 1, created_at: Time.now)
    assign(:versions, @versions)
  end

  it "renders a list of versions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @versions.first.name, :count => 2
    assert_select "tr>td", :text => @versions.first.created_at, :count => 2
    assert_select "tr>td", :text => @versions.first.number_of_users, :count => 2
  end
end
