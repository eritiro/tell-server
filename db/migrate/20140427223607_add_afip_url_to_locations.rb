class AddAfipUrlToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :afip_req, :string
    add_index :locations, :afip_req, unique: true
  end
end
