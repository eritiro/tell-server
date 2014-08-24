class Comment < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :location

  validates_presence_of :score, :author_id, :location_id
end
