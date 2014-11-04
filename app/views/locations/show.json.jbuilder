json.extract! @location, :id, :name, :address, :phone
json.photo_url absolute_url(@location.photo.url(:medium))
