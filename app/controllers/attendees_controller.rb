class AttendeesController < ApplicationController
  load_and_authorize_resource class: Location

  before_action :set_location

  def index
    @users = @location.attendees
  end

  def attend
    @location.attendees << current_user
    Event.log 'attend', current_user
    head :no_content
  end

  def leave
    current_user.update(location: nil)
    head :no_content
  end

private

  def set_location
    @location = Location.find(params[:location_id])
  end
end
