class ModifyAfipUrlIndex < ActiveRecord::Migration
  def change
    remove_index :locations, :afip_url
    add_index :locations, :afip_url, unique: false #because can be blank
  end
end
