json.array!(@locations) do |location|
  json.extract! location, :id, :name, :address, :phone
end
