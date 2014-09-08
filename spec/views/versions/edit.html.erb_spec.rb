require 'spec_helper'

describe "versions/edit" do
  before(:each) do
    @version = assign(:version, stub_model(Version,
      :name => "MyString",
      :hipotesis => "MyText",
      :blog_url => "MyString"
    ))
  end

  it "renders the edit version form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", version_path(@version), "post" do
      assert_select "input#version_name[name=?]", "version[name]"
      assert_select "textarea#version_hipotesis[name=?]", "version[hipotesis]"
      assert_select "input#version_blog_url[name=?]", "version[blog_url]"
    end
  end
end
