class UsersController < ApplicationController
  include UsersHelper

  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy, :invite]

  # GET /users
  # GET /users.json
  def index
    if params[:version_id].present?
      @users = Version.find(params[:version_id]).events.registration.map(&:user)
    else
      @users = User.all
    end
    @versions = Version.all

    if params[:commit] == 'Export'
      render xlsx: 'index', filename: "users-#{Time.zone.now}.xlsx"
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    current_user.notifications.where(from: @user, type: 'invite').update_all(read: true)
    @invited = Notification.where(from: current_user, to: @user, type: 'invite').count > 0
  end

  # GET /users/new
  def new
    @user = User.new
    @locations = Location.all
  end

  # GET /users/1/edit
  def edit
    @locations = Location.all
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def invite
    @user.notify(
      from:  current_user,
      text:  "Te invitó un trago.",
      title: "#{current_user}",
      type:  "invite")

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully notified.' }
      format.json { head :no_content }
    end
  end

  def profile
    @user = current_user
    @feeds = Feed.all
  end

  def alert
    User.where(location_id: nil).find_each do |user|
      send_system_notification user, "Warmapp", "#{user.username}! A donde salis esta noche?"
    end
    redirect_to users_path
  end

  def leave
    User.update_all(location_id: nil)
    @locations = Location.all
    redirect_to users_path
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :email, :password, :picture, :admin, :fake, :gender, :device_token, :birthday, :location_id)
  end
end
