json.extract! @user, :id, :username, :gender
json.picture absolute_url(@user.picture.url(:medium))
json.icon absolute_url(@user.picture.url(:icon))
json.was_invited @invited
json.location @user.location, :id, :name if @user.location