require 'spec_helper'

describe Location do
  it "has a valid factory" do
    build(:location).should be_valid
  end

  describe "afip_url" do
    it "should be unique" do
      create(:location, afip_url: "repeat")
      build(:location, afip_url: "repeat").should_not be_valid
    end

    it "could be nil" do
      create(:location, afip_url: nil)
      build(:location, afip_url: nil).should be_valid
    end
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
    end

    context "without comments" do
      it "returns nil" do
        build(:location).score.should eq nil
      end
    end
  end
end
