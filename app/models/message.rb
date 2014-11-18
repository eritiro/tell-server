class Message < ActiveRecord::Base
  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"

  validates_presence_of :from, :to

  default_scope { order('id ASC') }
end
