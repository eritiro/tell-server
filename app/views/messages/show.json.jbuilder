json.partial! 'messages/show', message: @message
json.notification do
  json.partial! 'notifications/show', notification: @notification
end
