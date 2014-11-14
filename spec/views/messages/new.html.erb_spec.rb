require 'spec_helper'

describe "messages/new" do
  before(:each) do
    @user =  build(:user, id: 1)
    assign(:user, @user)
    assign(:message, build(:message))
  end

  it "renders new message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_messages_path(@user), "post" do
      assert_select "input#message_text[name=?]", "message[text]"
    end
  end
end
