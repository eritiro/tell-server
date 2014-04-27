require 'spec_helper'

describe "comments/new" do
  before(:each) do
    @location = assign(:location, create(:location))    
    @comment = assign(:comment, build(:comment))
  end

  it "renders new comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", location_comments_path(@location), "post" do
      assert_select "textarea#comment_text[name=?]", "comment[text]"
      assert_select "input#comment_score[name=?]", "comment[score]"
    end
  end
end
