json.extract! @user, :id, :username, :authentication_token, :gender
json.picture absolute_url(@user.picture.url(:thumb))
json.unread_notifications @user.notifications.unread.count

if @user.location
  json.location do
    json.partial! 'locations/show', location: @user.location
  end
end

json.notifications do
  json.partial! 'notifications/index', notifications: @user.notifications
end

# deprecated:
json.attending_location_id @user.location_id