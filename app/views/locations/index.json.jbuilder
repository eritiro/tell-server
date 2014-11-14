json.array!(@locations) do |location|
  json.extract! location, :id, :name, :address, :phone
  json.photo location.photo.url(:thumb)
end
