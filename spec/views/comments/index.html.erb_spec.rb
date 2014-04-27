require 'spec_helper'

describe "comments/index" do
  before(:each) do
    assign(:location, build(:location))
    assign(:comments, build_list(:comment, 2, :text => "a comment text", :score => "4.5", :user => nil))
  end

  it "renders a list of comments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "a comment text".to_s, :count => 2
    assert_select "tr>td", :text => "4.5".to_s, :count => 2
  end
end
