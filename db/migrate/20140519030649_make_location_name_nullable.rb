class MakeLocationNameNullable < ActiveRecord::Migration
  def change
    change_column :locations, :name, :string, null: true
  end
end
