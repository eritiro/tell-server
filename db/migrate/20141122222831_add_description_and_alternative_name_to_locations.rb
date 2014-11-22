class AddDescriptionAndAlternativeNameToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :description, :text
    add_column :locations, :alternative_name, :string
  end
end
