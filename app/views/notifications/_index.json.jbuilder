json.array!(notifications) do |notification|
  json.extract! notification, :id, :type, :title, :text, :created_at, :read
  json.from do
    json.id       notification.from.id
    json.username notification.from.username
    json.thumb    absolute_url(notification.from.picture(:icon))
  end
end