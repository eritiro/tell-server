json.array!(feeds) do |feed|
  json.extract! feed, :id, :created_at, :title, :detail, :action, :type
  json.url feed_url(feed, format: :json)
  json.users(feed.users) do |user|
    json.extract! user, :id
    json.icon absolute_url(user.picture(:icon))
  end
end
