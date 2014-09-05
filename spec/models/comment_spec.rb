require 'spec_helper'

describe Comment do
  it "has a valid factory" do
    build(:comment).should be_valid
  end

  it "validates presence of score" do
    build(:comment, score: nil).should_not be_valid
  end

  it "validates score is not zero" do
    build(:comment, score: 0).should_not be_valid
  end

  it "validates score is not six" do
    build(:comment, score: 6).should_not be_valid
  end

  it "validates score is an integer" do
    build(:comment, score: 3.5).should_not be_valid
  end

  it "validates presence of author" do
    build(:comment, author: nil).should_not be_valid
  end

  it "validates presence of location" do
    build(:comment, location: nil).should_not be_valid
  end
end
