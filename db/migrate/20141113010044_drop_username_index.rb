class DropUsernameIndex < ActiveRecord::Migration
  def change
    remove_index :users, column: :username
  end
end
