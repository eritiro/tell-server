json.partial! 'locations/show', location: @location

# deprecated
json.photo absolute_url(@location.photo.url(:medium))
