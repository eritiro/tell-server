json.array!(@notifications) do |notification|
  json.extract! notification, :id, :type, :from_id, :to_id, :text
  json.url notification_url(notification, format: :json)
end
