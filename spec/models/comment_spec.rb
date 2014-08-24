require 'spec_helper'

describe Comment do
  it "has a valid factory" do
    build(:comment).should be_valid
  end

  it "validates presence of score" do
    build(:comment, score: nil).should_not be_valid
  end

  it "validates presence of author" do
    build(:comment, author: nil).should_not be_valid
  end

  it "validates presence of location" do
    build(:comment, location: nil).should_not be_valid
  end
end
