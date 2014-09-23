class AddVersionNumberToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :version_number, :string
  end
end
