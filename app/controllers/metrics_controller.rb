class MetricsController < ApplicationController
  load_and_authorize_resource class: Event

  def index
    @versions = Version.all
    @events = []
    Event::TYPES.each do |event_type|
      values = []
      @versions.each do |version|
        if (!version.has_landing and event_type == 'landing') or version.number_of_users == 0
          values << nil
        else
          values << 100 * version.events_for(event_type).count / version.number_of_users
        end
      end
      @events << { key: event_type, values: values }
    end
  end
end
