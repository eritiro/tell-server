json.extract! @user, :id, :username, :email, :completed_tutorial, :gender, :guessed_username, :birthday
json.user_photos @user.user_photos.map(&:url)
json.facebook_photos @data[:photos]
