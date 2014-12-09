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
  end
end
