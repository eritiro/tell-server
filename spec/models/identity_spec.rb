require 'spec_helper'

describe Identity do
  it "has a valid factory" do
    build(:identity).should be_valid
  end
end
