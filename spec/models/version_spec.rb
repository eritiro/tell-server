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
      create_list(:event, 2, :search, user: user)
      version.events.count.should eq 0
    end

    it "ignores administrators" do
      version = create(:version)
      admin = create(:admin)
      create(:event, :search, user: admin)
      version.events.count.should eq 0
    end

    context "being an old version" do
      it "ignores new events of its users" do
        version = create(:version)
        user = create(:user)
        Timecop.travel(1.minute.from_now)
        create(:version)
        create(:event, :search, user: user)

        version.events.count.should eq 0
      end
    end
  end

  describe "number_of_users" do
    context "having landings" do
      it "returns landings" do
        version = create(:version)
        create_list(:event, 1, :landing)
        version.number_of_users.should eq 1
      end

      context "being the last version" do
        it "returns the count of last event registrations" do
          version = create(:version)
          create_list(:event, 2, :landing)
          version.number_of_users.should eq 2
        end

        it "ignores previous registrations" do
          event_time = Time.now
          create(:event, :landing)
          Timecop.travel(1.minute.from_now)
          version = create(:version)
          version.number_of_users.should eq 0
        end
      end

      context "not being the last version" do
        it "returns the count of last event registrations after the new version" do
          version = create(:version)
          Timecop.travel(1.minute.from_now)
          create(:event, :landing)
          Timecop.travel(1.minute.from_now)
          create(:version)
          Timecop.travel(1.minute.from_now)
          create(:event, :landing)

          version.number_of_users.should eq 1
        end

        it "ignores previous registrations" do
          event_time = Time.now
          create(:event, :landing)
          Timecop.travel(1.minute.from_now)
          version = create(:version)
          version.number_of_users.should eq 0
        end
      end
    end
  end

  describe "days_online" do
    context "being the last version" do
      it "returns the days since it was created" do
        version = create(:version)
        Timecop.travel(2.day.from_now)
        version.days_online.should eq 2
      end
    end

    context "not being the last version" do
      it "returns the days until the next version" do
        version = create(:version)
        Timecop.travel(1.day.from_now)
        create(:version)
        Timecop.travel(2.day.from_now)
        version.days_online.should eq 1
      end
    end
  end
end
