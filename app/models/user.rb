class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token

  include ApplicationHelper

  has_attached_file :picture, :styles => { medium: '320x320#', thumb: '160x160#', icon: '50x50#' }, :default_url => "/images/user_missing_:style.png"
  has_many :identities, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :user_photos, dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: "to_id", dependent: :destroy
  has_many :notifications, foreign_key: "to_id"
  belongs_to :location, inverse_of: :attendees

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates_inclusion_of :gender, in: ['male', 'female'], allow_blank: true

  scope :real, -> { where(fake: false) }
  scope :male, -> { where(gender: 'male') }
  scope :female, -> { where(gender: 'female') }


  def to_s
    username
  end

  def notify attributes
    notifications.where(from_id: attributes[:from].id, type: attributes[:type]).destroy_all
    notification = notifications.create(attributes)
    if device_token.present? && notification.unread
      GCM.send_notification device_token, {
        id: notification.id,
        title: notification.title,
        message: notification.text,
        type: notification.type,
        from_id:       notification.from.id,
        from_username: notification.from.username,
        from_thumb:    absolute_url(notification.from.picture(:icon)),
        read: notification.read,
        msgcnt: notifications.unread.count
      }
    end
    notification
  end

private

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = Devise.friendly_token
    end
  end
end
