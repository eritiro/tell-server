require 'spec_helper'

describe Version do
  it "has a valid factory" do
    build(:version).should be_valid
  end

  it "validates presence of name" do
    build(:version, name: nil).should_not be_valid
  end

  describe "events" do
    it "ignores new events of old users" do
      user = create(:user)
      Timecop.travel(1.minute.from_now)
      version = create(:version)
      create_list(:event, 2, :scan, user: user)
      version.events.count.should eq 0
    end

    it "ignores administrators" do
      version = create(:version)
      admin = create(:admin)
      create(:event, :scan, user: admin)
      version.events.count.should eq 0
    end
  end

  describe "number_of_users" do
    context "being the last version" do
      it "returns the count of last event registrations" do
        version = create(:version)
        create_list(:event, 2, :registration)
        version.number_of_users.should eq 2
      end

      it "ignores previous registrations" do
        event_time = Time.now
        create(:event, :registration)
        Timecop.travel(1.minute.from_now)
        version = create(:version)
        version.number_of_users.should eq 0
      end
    end

    context "not being the last version" do
      it "returns the count of last event registrations after the new version" do
        version = create(:version)
        Timecop.travel(1.minute.from_now)
        create(:event, :registration)
        Timecop.travel(1.minute.from_now)
        create(:version)
        Timecop.travel(1.minute.from_now)
        create(:event, :registration)

        version.number_of_users.should eq 1
      end

      it "ignores previous registrations" do
        event_time = Time.now
        create(:event, :registration)
        Timecop.travel(1.minute.from_now)
        version = create(:version)
        version.number_of_users.should eq 0
      end
    end
  end
end
