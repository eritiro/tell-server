class SocialController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check

  def facebook
    OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = "SSLv23"
    @graph = Koala::Facebook::API.new(params[:token])
    @data = {}

    @data[:me], photos = @graph.batch do |batch_api|
      batch_api.get_object('me')
      batch_api.get_connections('me', 'photos', :fields=>"source")
    end

    @data[:photos] = photos.map { |p| p["source"] }
    @user = find_or_create_user(@data[:me])

  rescue Koala::Facebook::AuthenticationError
    access_denied
  end

  def photo_select
    @user = User.find(params[:id])
    @user.user_photos = params[:photos].map { |photo| UserPhoto.new(url: photo) }
    head :no_content
  rescue Koala::Facebook::AuthenticationError
    access_denied
  end

private

  def find_or_create_user(me)
    identity = Identity.find_or_create_by(uid: me["id"], provider: "facebook")
    user = identity.user
    if user.nil?
      email = me["email"] ? me["email"] : "facebook-#{me["id"]}@tell.com"
      user = User.where(:email => email).first if email

      if user.nil?
        user = User.new(
          guessed_username: me["name"],
          email: email,
          gender:  me["gender"],
          birthday: Date.strptime(me["birthday"], "%m/%d/%Y"),
          password: Devise.friendly_token[0,20]
        )

        user.save!
        Event.log 'registration', user
      end
      if identity.user != user
        identity.user = user
        identity.save!
      end
    end
    user
  end
end
