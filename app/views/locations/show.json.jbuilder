json.extract! @location, :id, :name, :address, :phone, :score
json.comments @location.comments do |comment|
  json.extract! comment, :text, :score, :created_at
  json.author comment.author, :id, :username
end