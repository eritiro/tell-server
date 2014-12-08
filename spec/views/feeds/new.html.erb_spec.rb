require 'spec_helper'

describe "feeds/new" do
  before(:each) do
    assign(:feed, stub_model(Feed,
      :title => "MyString",
      :detail => "MyString",
      :type => ""
    ).as_new_record)
  end

  it "renders new feed form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", feeds_path, "post" do
      assert_select "input#feed_title[name=?]", "feed[title]"
      assert_select "input#feed_detail[name=?]", "feed[detail]"
      assert_select "input#feed_action[name=?]", "feed[action]"
      assert_select "select#feed_type[name=?]", "feed[type]"
    end
  end
end
