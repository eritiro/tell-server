class AddRelevanceToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :relevance, :integer
  end
end
