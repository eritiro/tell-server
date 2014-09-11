require 'spec_helper'

describe "users/index" do
  before(:each) do
    @identities = []
    @identities << build(:identity, provider: 'facebook')
    @identities << build(:identity, provider: 'twitter')

    @users = assign(:users, build_list(:user, 2, identities: @identities))
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", text: @users.first.username.to_s
    assert_select "tr>td", text: @users.last.username.to_s
    assert_select "tr>td", text: @users.first.email.to_s
    assert_select "tr>td", text: @users.last.email.to_s
  end

  it "renders the social networks providers" do
    render
    assert_select "tr>td", text: "facebook, twitter"
  end
end
