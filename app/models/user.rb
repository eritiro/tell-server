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
  has_many :received_messages, class_name: "Message", foreign_key: "to_id", dependent: :destroy
  has_many :notifications, foreign_key: "to_id"
  belongs_to :location, inverse_of: :attendees

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates_inclusion_of :gender, in: ['male', 'female']

  def to_s
    username
  end

  def notify attributes
    notifications.where(from_id: attributes[:from].id, type: attributes[:type]).destroy_all
    notification = notifications.create(attributes)
    if device_token.present?
      GCM.send_notification device_token, {
        title: notification.title,
        message: notification.text,
        type: notification.type,
        from_id: notification.from_id,
        unread: notifications.unread.count
      }
    end
  end

private

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = Devise.friendly_token
    end
  end
end
