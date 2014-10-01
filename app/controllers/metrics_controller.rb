class MetricsController < ApplicationController
  load_and_authorize_resource class: Event

  def index
    @versions = Version.all
    @events = []
    Event::TYPES.each do |event_type|
      values = []
      @versions.each do |version|
        if version.number_of_users == 0
          values << nil
        elsif event_type == 'landing'
          if version.has_landing
            values << 100 * version.events_without_user.where(event_type: event_type).count / version.number_of_users
          else
            values << nil
          end
        else
          values << 100 * version.events.where(event_type: event_type).count / version.number_of_users
        end
      end
      @events << { key: event_type, values: values }
    end
  end
end
