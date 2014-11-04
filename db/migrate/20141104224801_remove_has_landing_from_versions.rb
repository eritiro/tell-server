class RemoveHasLandingFromVersions < ActiveRecord::Migration
  def change
    remove_column :versions, :has_landing, :boolean
  end
end
