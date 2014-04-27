require 'spec_helper'

describe "comments/show" do
  before(:each) do
    @comment = assign(:comment, build(:comment,
      :text => "Text",
      :score => "3.5",
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Text/)
    rendered.should match(/3.5/)
  end
end
