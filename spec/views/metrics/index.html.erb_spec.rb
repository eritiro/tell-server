require 'spec_helper'

describe "metrics/index" do
  before(:each) do
    @versions = build_list(:version, 2, id: 1, created_at: Time.now)
    assign(:versions, @versions)
  end

  context "with some events" do
    before do
      @events = [
        { key: :registration, values: [100, 100] },
        { key: :scan, values: [50, 50] }]
      assign(:events, @events)
    end

    it "renders a column per versions" do
      render
      assert_select "tr>th", count: 1 + @versions.count
    end

    it "renders a list of event_types" do
      render
      assert_select "tr>td", text: "registration"
      assert_select "tr>td", text: "100%", count: 2
      assert_select "tr>td", text: "50%", count: 2
    end
  end

  context "with no users for versions" do
    before do
      @events = [
        { key: :registration, values: [nil, nil] },
        { key: :scan, values: [nil, nil] }]
      assign(:events, @events)
    end

    it "renders a list of event_types" do
      render
      assert_select "tr>td", text: "registration"
      assert_select "tr>td", text: "-", count: 4
    end
  end
end