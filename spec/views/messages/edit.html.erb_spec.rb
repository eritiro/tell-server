require 'spec_helper'

describe "messages/edit" do
  before(:each) do
    @user =  create(:user)
    @message = create(:message, to: @user)
    assign(:user, @user)
    assign(:message, @message)
  end

  it "renders the edit message form" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_message_path(@user, @message), "post" do
      assert_select "input#message_text[name=?]", "message[text]"
    end
  end
end
