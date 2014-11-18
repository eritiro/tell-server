json.extract! @location, :id, :name, :address, :phone
json.photo absolute_url(@location.photo.url(:medium))
