json.array!(@users) do |user|
  json.extract! user, :id, :username, :gender
  json.picture absolute_url(user.picture.url(:thumb))
end
