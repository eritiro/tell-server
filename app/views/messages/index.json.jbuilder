json.array!(@messages) do |message|
  json.extract! message, :id, :from_id, :to_id, :text
  json.url message_url(message, format: :json)
end
