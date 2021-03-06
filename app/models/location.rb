class Location < ActiveRecord::Base
  has_many :attendees, class_name: "User", inverse_of: :location

  has_attached_file :photo, styles: { medium: "400>x200", thumb: "100x100>" }, :default_url => "/images/location_missing_:style.jpg"
  has_attached_file :banner, :styles => { :medium => "600x300!" }

  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  default_scope { order('relevance desc') }
  def to_s
    name
  end
end