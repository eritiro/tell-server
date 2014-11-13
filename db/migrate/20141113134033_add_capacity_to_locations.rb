class AddCapacityToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :capacity, :integer
  end
end
