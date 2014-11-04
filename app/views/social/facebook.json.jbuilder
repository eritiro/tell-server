json.extract! @user, :id, :username, :email, :completed_tutorial, :gender, :guessed_username, :birthday, :authentication_token
json.user_photos @user.user_photos.map(&:url)
json.facebook_photos @data[:photos]
