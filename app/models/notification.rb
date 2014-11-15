class Notification < ActiveRecord::Base
  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"

  validates_presence_of :from, :to, :type
  self.inheritance_column = :pomelo_rocks

  default_scope { order('id DESC') }
end
