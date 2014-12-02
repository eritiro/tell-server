require 'spec_helper'

describe "locations/index" do
  before(:each) do
    assign(:locations, build_list(:location, 2,
        name: "Name",
        address: "Address",
        relevance: 10,
        photo_file_name: "photo.jpg"))
  end

  it "renders a list of locations" do
    render
    assert_select "tr>td", :text => "Name", :count => 2
    assert_select "tr>td", :text => "Address", :count => 2
    assert_select "tr>td", :text => "10", :count => 2
  end
end
