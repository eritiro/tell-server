class AddAfipUrlToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :afip_url, :string
    add_index :locations, :afip_url, unique: true
  end
end
