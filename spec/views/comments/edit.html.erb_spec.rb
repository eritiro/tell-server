require 'spec_helper'

describe "comments/edit" do
  before(:each) do
    @comment = assign(:comment, stub_model(Comment,
      :text => "MyString",
      :score => "9.99",
      :user => nil
    ))
  end

  it "renders the edit comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", comment_path(@comment), "post" do
      assert_select "input#comment_text[name=?]", "comment[text]"
      assert_select "input#comment_score[name=?]", "comment[score]"
      assert_select "input#comment_user[name=?]", "comment[user]"
    end
  end
end
