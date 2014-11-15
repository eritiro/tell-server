require 'spec_helper'

describe "notifications/index" do
  before(:each) do
    @from = build(:user, username: "Emiliano")
    @to   = build(:user, username: "Diego")

    assign(:notifications,
      build_list(:notification, 2, from: @from, to: @to, text: "Something"))
  end

  it "renders a list of notifications" do
    render
    assert_select "tr>td", :text => @from.to_s, :count => 2
    assert_select "tr>td", :text => @to.to_s, :count => 2
    assert_select "tr>td", :text => "Something".to_s, :count => 2
  end
end
