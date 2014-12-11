json.array!(notifications) do |notification|
  json.partial! 'notifications/show', notification: notification
end