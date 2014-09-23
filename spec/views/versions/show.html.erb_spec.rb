require 'spec_helper'

describe "versions/show" do
  before(:each) do
    @version = assign(:version, build(:version,
      :name => "Name",
      :hipotesis => "MyText",
      :blog_url => "Blog Url",
      :version_number => "1.0.0"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/Blog Url/)
    rendered.should match(/1.0.0/)
  end
end
