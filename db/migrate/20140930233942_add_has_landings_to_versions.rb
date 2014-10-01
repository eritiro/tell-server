class AddHasLandingsToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :has_landing, :boolean, default: true
  end
end
