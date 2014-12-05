json.extract! location, :id, :name, :address, :phone, :description
json.thumb     absolute_url(location.photo.url(:thumb)) if location.photo.exists?
json.banner    absolute_url(location.banner.url(:medium)) if location.banner.exists?
json.capacity  location.capacity

json.attendees do
  json.partial! 'attendees/index', attendees: location.attendees
end
json.attendees_count location.attendees.count