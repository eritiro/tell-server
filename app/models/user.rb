class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_save :ensure_authentication_token

  has_attached_file :picture, :styles => { :medium => "400x400>", :thumb => "100x100>" }, :default_url => "/assets/user_missing_:style.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  def to_s
    email
  end

private

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = Devise.friendly_token
    end
  end
end
