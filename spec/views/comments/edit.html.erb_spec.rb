require 'spec_helper'

describe "comments/edit" do
  before(:each) do
    @location = assign(:location, create(:location))    
    @comment = assign(:comment, create(:comment))
  end

  it "renders the edit comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", location_comment_path(@location, @comment), "post" do
      assert_select "textarea#comment_text[name=?]", "comment[text]"
      assert_select "input#comment_score[name=?]", "comment[score]"
    end
  end
end
