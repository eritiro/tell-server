json.array!(@notifications) do |notification|
  json.extract! notification, :id, :type, :from_id, :text, :created_at, :read
end
