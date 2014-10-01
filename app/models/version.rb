class Version < ActiveRecord::Base
  validates_presence_of :name

  def events
    events = events_without_user.joins(:user).where("users.admin" => false).where("users.created_at >= ?", created_at)
    if next_version.nil?
      events
    else
      events.where('events.created_at < ?', next_version.created_at)
    end
  end

  def events_without_user
    if next_version.nil?
      Event.all
    else
      Event.where('events.created_at < ?', next_version.created_at)
    end
  end

  def number_of_users
    @number_of_users ||= if has_landing
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
