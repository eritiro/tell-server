require 'spec_helper'

describe "attendees/index" do
  before(:each) do
    assign(:users, build_list(:user, 2))
  end

  it "renders a list of attendees" do
    render
    assert_select "tr>td>a", :text => "Show", :count => 2
  end
end
