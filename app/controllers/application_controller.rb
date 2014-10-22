class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  respond_to :html, :json
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?
  check_authorization :unless => :devise_controller?
  rescue_from CanCan::AccessDenied, with: :access_denied
private

  def authenticate_user_from_token!
    user_id = request.headers["User-Id"]
    user    = user_id.present? && User.find_by_id(user_id)

    if user && Devise.secure_compare(user.authentication_token, request.headers["User-Token"])
      logger.debug "Authenticated via token"
      sign_in user, store: false
    end
  end

  def access_denied
    render :file => "public/401.html", :status => :unauthorized, layout: nil
  end

  def configure_permitted_parameters
    #devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :picture, :birthday, :gender) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :picture, :completed_tutorial, :birthday, :gender) }
  end
end
