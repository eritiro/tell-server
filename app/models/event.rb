class Event < ActiveRecord::Base
  TYPES = ['landing', 'registration', 'attend', 'chat']

  belongs_to :user
  validates_presence_of :event_type
  validates_inclusion_of :event_type, in: TYPES

  scope :landing, -> { where(event_type: 'landing') }
  scope :registration, -> { where(event_type: 'registration') }

  def self.log event_type, user
    find_or_create_by event_type: event_type, user: user
  end

  def self.log_without_user event_type, ip, user_agent
    return if user_agent.include? 'Googlebot'
    find_or_create_by! event_type: event_type, ip: ip, user_agent: user_agent
  end
end
