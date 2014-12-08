require 'spec_helper'

describe Feed do
  it "has a valid factory" do
    build(:feed).should be_valid
  end

  it "has and belongs to many users" do
    build(:feed).should respond_to(:users)
  end

  describe "default scope" do
    it "sorts by id DESC" do
      first = create(:feed)
      second = create(:feed)
      Feed.all.should eq([second, first])
    end
  end
end
