class Location < ActiveRecord::Base
  has_many :comments
  has_attached_file :photo, styles: { medium: "400>x200", thumb: "100x100>" }, :default_url => "/images/location_missing_:style.jpg"
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_uniqueness_of :afip_url, :allow_blank => true

  def score
    return nil if comments.empty?
    comments.last_from_each_user.map {|c| c.score}.reduce(0, :+) / comments.last_from_each_user.count
  end
end
