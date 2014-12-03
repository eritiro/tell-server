json.array!(@locations) do |location|
  json.extract! location, :id, :name, :address, :phone
  json.thumb absolute_url(location.photo.url(:thumb)) if location.photo.exists?

  #deprecated
  json.photo absolute_url(location.photo.url(:thumb))
end
