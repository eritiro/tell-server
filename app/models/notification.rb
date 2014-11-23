class Notification < ActiveRecord::Base
  TYPES = ['message', 'invite']

  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"

  validates_presence_of :from, :to, :type
  validates_inclusion_of :type, in: TYPES

  self.inheritance_column = :pomelo_rocks

  default_scope { order('id DESC') }
  scope :unread, -> { where(read: false) }

  def unread
    not read
  end
end
