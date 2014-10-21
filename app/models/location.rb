class Location < ActiveRecord::Base
  has_many :comments
  has_attached_file :photo, styles: { medium: "400>x200", thumb: "100x100>" }, :default_url => "/images/location_missing_:style.jpg"
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def score
    return nil if comments.last_from_each_user.empty?
    comments.last_from_each_user.map {|c| c.score}.reduce(0, :+) / comments.last_from_each_user.count
  end
end
