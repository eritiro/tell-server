require 'spec_helper'

describe Location do
  describe "score" do
    context "with comments" do
      it "returns the average of its comment scores" do
        location = build(:location)
        location.comments << build(:comment, score: 4)
        location.comments << build(:comment, score: 5)
        location.save!
        location.score.should eq 4.5
      end
    end

    context "without comments" do
      it "returns nil" do
        build(:location).score.should eq nil
      end
    end
  end
end
