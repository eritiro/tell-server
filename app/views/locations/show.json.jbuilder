json.extract! @location, :id, :name, :address, :phone, :description
json.thumb  absolute_url(@location.photo.url(:thumb)) if @location.photo.exists?
json.banner absolute_url(@location.banner.url(:medium)) if @location.banner.exists?
json.attendees @location.attendees.count
json.capacity  @location.capacity

# deprecated
json.photo absolute_url(@location.photo.url(:medium))
