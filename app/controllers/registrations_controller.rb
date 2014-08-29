class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_scope!, only: :update
  before_filter :authenticate_user_from_token!
  def update
    @user = User.find(current_user.id)

    if @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
      sign_in @user, :bypass => true
      respond_with @user, location: after_update_path_for(resource)
    else
      respond_with @user
    end
  end
end