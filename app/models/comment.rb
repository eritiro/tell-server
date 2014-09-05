class Comment < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :location

  scope :last_from_each_user, -> {
    where("not exists(select * from comments newer where newer.author_id = comments.author_id and newer.id > comments.id)") }

  validates_presence_of :score, :author_id, :location_id
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5, allow_blank: true }
end
