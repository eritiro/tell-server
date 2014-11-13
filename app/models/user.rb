class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token

  has_attached_file :picture, :styles => { :medium => "400x400>", :thumb => "100x100>" }, :default_url => "/images/user_missing_:style.png"
  has_many :identities, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :user_photos, dependent: :destroy
  belongs_to :location

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates_inclusion_of :gender, in: ['male', 'female']

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
