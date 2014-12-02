class AddUserAgentToEvents < ActiveRecord::Migration
  def change
    add_column :events, :user_agent, :string
  end
end
