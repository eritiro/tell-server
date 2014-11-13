class RemoveGuessedUsernameFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :guessed_username, :string
  end
end
