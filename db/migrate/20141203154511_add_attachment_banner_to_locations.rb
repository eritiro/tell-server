class AddAttachmentBannerToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :banner
    end
  end

  def self.down
    remove_attachment :locations, :banner
  end
end
