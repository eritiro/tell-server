class AddFromDeletedToDeletedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :from_deleted, :boolean, default: false
    add_column :messages, :to_deleted, :boolean, default: false
  end
end
