class AddLocationIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :location_id, :integer
  end
end
