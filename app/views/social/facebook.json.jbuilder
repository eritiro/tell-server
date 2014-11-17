json.extract! @user, :id, :username, :authentication_token
json.unread_notifications @user.notifications.unread.count