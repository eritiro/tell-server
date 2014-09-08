class Version < ActiveRecord::Base
  validates_presence_of :name

  def events
    next_version = Version.where('id > ?', id).first
    events = Event.joins(:user).where("users.admin" => false).where("users.created_at >= ?", created_at)
    if next_version.nil?
      events
    else
      events.where('users.created_at < ?', next_version.created_at)
    end
  end

  def number_of_users
    events.where(event_type: 'registration').count
  end
end
