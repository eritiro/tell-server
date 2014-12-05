json.extract!  @location, :id, :name, :address, :phone, :description
json.thumb     absolute_url(@location.photo.url(:thumb)) if @location.photo.exists?
json.photo     absolute_url(@location.photo.url(:medium))
json.capacity  @location.capacity
json.attendees @location.attendees.count
