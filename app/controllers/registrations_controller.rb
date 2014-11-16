class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_scope!, only: :update
  before_filter :authenticate_user_from_token!
  after_filter :log_event, only: :create

  def update
    @user = User.find(current_user.id)

    successfully_updated = if params[:user][:current_password]
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      sign_in @user, :bypass => true
      respond_with @user, location: after_update_path_for(resource)
    else
      respond_with @user
    end
  end

private

  def log_event
    if resource.persisted?
      Event.log "registration", resource
    end
  end
end