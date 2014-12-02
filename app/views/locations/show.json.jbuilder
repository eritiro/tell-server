json.extract! @location, :id, :name, :address, :phone, :description
json.photo_thumb  absolute_url(@location.photo.url(:thumb))
json.photo_medium absolute_url(@location.photo.url(:medium))
json.attendees @location.attendees.count

# deprecated
json.photo absolute_url(@location.photo.url(:medium))
