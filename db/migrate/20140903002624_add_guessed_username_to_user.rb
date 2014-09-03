class AddGuessedUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :guessed_username, :string
  end
end
