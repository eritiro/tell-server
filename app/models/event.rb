class Event < ActiveRecord::Base
  TYPES = ['registration', 'scan', 'comment']

  belongs_to :user
  validates_presence_of :event_type, :user
  validates_inclusion_of :event_type, in: TYPES

  scope :registration, -> { where(event_type: 'registration') }

  def self.log event_type, user
    find_or_create_by event_type: event_type, user: user
  end
end
