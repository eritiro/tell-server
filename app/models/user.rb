class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]
  before_save :ensure_authentication_token

  has_attached_file :picture, :styles => { :medium => "400x400>", :thumb => "100x100>" }, :default_url => "/images/user_missing_:style.png"
  has_many :identities

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  def to_s
    email
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_or_create_by(uid: auth.uid, provider: auth.provider)
    user = identity.user
    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = email_is_verified ? auth.info.email : "#{auth.provider}#{auth.uid}@tell.com"
      user = User.where(:email => email).first if email

      if user.nil?
        user = User.new(
          guessed_username: auth.extra.raw_info.name,
          email: email,
          password: Devise.friendly_token[0,20]
        )

        user.save!
      end
      if identity.user != user
        identity.user = user
        identity.save!
      end
    end
    user
  end

private

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = Devise.friendly_token
    end
  end
end
