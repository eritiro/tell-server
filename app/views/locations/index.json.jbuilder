json.array!(@locations) do |location|
  json.extract! location, :id, :name, :address, :phone
  json.photo_thumb absolute_url(location.photo.url(:thumb))

  #deprecated
  json.photo absolute_url(location.photo.url(:thumb))
end
