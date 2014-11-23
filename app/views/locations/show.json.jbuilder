json.extract! @location, :id, :name, :address, :phone, :description
json.photo absolute_url(@location.photo.url(:medium))
json.attendees @location.attendees.count
