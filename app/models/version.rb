class Version < ActiveRecord::Base
  validates_presence_of :name

  def events
    events_without_user.joins(:user).where("users.admin" => false).where("users.created_at >= ?", created_at)
  end

  def events_without_user
    events_without_user = Event.where("events.created_at >= ?", created_at)
    if next_version.nil?
      events_without_user
    else
      events_without_user.where('events.created_at < ?', next_version.created_at)
    end
  end

  def events_for event_type
    if event_type == 'landing'
      events_without_user.where(event_type: 'landing')
    else
      events.where(event_type: event_type)
    end
  end

  def number_of_users
    if has_landing
      events_without_user.landing.count
    else
      events.registration.count
    end
  end

  def days_online
    if next_version.nil?
      (Time.zone.now.to_date - created_at.to_date).to_i
    else
      (next_version.created_at.to_date - created_at.to_date).to_i
    end
  end

private

  def next_version
    Version.where('id > ?', id).first
  end
end
