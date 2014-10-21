require 'spec_helper'

describe Location do
  it "has a valid factory" do
    build(:location).should be_valid
  end

  describe "score" do
    context "with comments" do
      it "returns the average of its comment scores" do
        location = build(:location)
        location.comments << build(:comment, score: 4)
        location.comments << build(:comment, score: 5)
        location.save!
        location.score.should eq 4.5
      end

      it "returns the last score of a user" do
        location = create(:location)
        user = create(:user)
        location.comments << build(:comment, score: 1, author: user)
        location.comments << build(:comment, score: 5, author: user)
        location.save!
        location.score.should eq 5.0
      end
    end

    context "without comments" do
      it "returns nil" do
        build(:location).score.should eq nil
      end
    end
  end
end
