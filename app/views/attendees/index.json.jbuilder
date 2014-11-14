json.array!(@attendees) do |attendee|
  json.extract! attendee, :id
  json.url attendee_url(attendee, format: :json)
end
