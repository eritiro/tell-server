json.array!(@messages) do |message|
  json.extract! message, :id, :text, :created_at
  json.mine message.from == current_user
end
