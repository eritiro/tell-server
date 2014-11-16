json.extract! @user, :id, :username, :completed_tutorial, :email, :created_at, :updated_at
json.picture absolute_url(@user.picture.url(:original))
json.was_invited @invited