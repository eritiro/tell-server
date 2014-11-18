json.extract! @user, :id, :username, :completed_tutorial, :email, :created_at, :updated_at
json.picture absolute_url(@user.picture.url(:medium))
json.was_invited @invited
json.location @user.location, :id, :name if @user.location