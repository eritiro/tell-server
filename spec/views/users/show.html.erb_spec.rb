require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = build(:user)
    @event = build(:event)
    @user.events << @event
    assign(:user, @user)
  end

  it "renders attributes" do
    render

    rendered.should match(@user.username)
    rendered.should match(@user.email)
  end

  it "renders events" do
    render

    rendered.should match(@event.event_type)
  end
end
