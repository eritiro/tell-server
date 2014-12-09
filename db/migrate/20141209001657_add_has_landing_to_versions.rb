class AddHasLandingToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :has_landing, :boolean
  end
end
