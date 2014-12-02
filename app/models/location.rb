class Location < ActiveRecord::Base
  has_many :attendees, class_name: "User", inverse_of: :location

  has_attached_file :photo, styles: { medium: "400>x200", thumb: "100x100>" }, :default_url => "/images/location_missing_:style.jpg"
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def to_s
    name
  end
end