json.extract! @user, :id, :username, :gender
json.picture absolute_url(@user.picture.url(:medium))
json.was_invited @invited
json.location @user.location, :id, :name if @user.location