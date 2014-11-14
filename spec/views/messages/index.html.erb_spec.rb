require 'spec_helper'

describe "messages/index" do
  before(:each) do
    @from = build(:user, username: 'Emiliano')
    @to   = build(:user, username: 'Diego')
    assign(:messages, build_list(:message, 2, text: 'pomeeelo', from: @from, to: @to))
  end

  it "renders a list of messages" do
    render
    assert_select "tr>td", :text => @from.username, :count => 2
    assert_select "tr>td", :text => @to.username, :count => 2
    assert_select "tr>td", :text => "pomeeelo", :count => 2
  end
end
