require 'spec_helper'

describe "locations/index" do
  before(:each) do
    assign(:locations, build_list(:location, 2,
        name: "Name",
        address: "Address",
        phone: "Phone",
        photo_file_name: "photo.jpg"))
  end

  it "renders a list of locations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name", :count => 2
    assert_select "tr>td", :text => "Address", :count => 2
    assert_select "tr>td", :text => "Phone", :count => 2
  end
end
