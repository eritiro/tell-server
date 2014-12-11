class MetricsController < ApplicationController
  load_and_authorize_resource class: Event

  def index
    @versions = Version.all
    @events = []
    last_events = {}
    Event::TYPES.each do |event_type|
      values = []
      @versions.each do |version|
        events = 0
        accumulated = if (!version.has_landing and event_type == 'landing') or version.number_of_users == 0
          nil
        else
          events = version.events_for(event_type).count
          100 * events / version.number_of_users
        end
        compared = if last_events[version] && last_events[version] > 0
          100 - (100 * events / last_events[version])
        else
          nil
        end
        values << { accumulated: accumulated, compared: compared }
        last_events[version] = events
      end
      @events << { key: event_type, values: values }
    end

    @users_count = User.real.count
    @male_count = User.real.male.count
    @female_count = User.real.female.count

    @locations = Location.select("locations.id, locations.name, count(users.id) as attendees_count").
      joins(:attendees).
      group("locations.id, locations.name").
      where("users.fake = false").
      order("attendees_count DESC").
      limit(10)
  end
end
