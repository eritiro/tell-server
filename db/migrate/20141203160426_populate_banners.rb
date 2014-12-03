class PopulateBanners < ActiveRecord::Migration
  include ApplicationHelper
  def up
    Location.all.each do |location|
      location.banner = URI.parse(absolute_url(location.photo(:original))) if location.photo.exists?
      location.save!
    end
  end

  def down
    # do nothing
  end
end
