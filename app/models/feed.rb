class Feed < ActiveRecord::Base
  self.inheritance_column = :pomelo_rocks
  has_and_belongs_to_many :users
  validates_presence_of :type
  default_scope { order('id DESC') }
end
