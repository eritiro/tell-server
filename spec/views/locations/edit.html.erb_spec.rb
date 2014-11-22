require 'spec_helper'

describe "locations/edit" do
  before(:each) do
    @location = assign(:location, stub_model(Location,
      :name => "MyString",
      :address => "MyString",
      :phone => "MyString"
    ))
  end

  it "renders the edit location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", location_path(@location), "post" do
      assert_select "input#location_name[name=?]", "location[name]"
      assert_select "input#location_alternative_name[name=?]", "location[alternative_name]"
      assert_select "input#location_address[name=?]", "location[address]"
      assert_select "input#location_phone[name=?]", "location[phone]"
      assert_select "textarea#location_description[name=?]", "location[description]"
    end
  end
end
