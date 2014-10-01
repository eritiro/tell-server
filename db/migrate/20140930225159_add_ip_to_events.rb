class AddIpToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ip, :string
  end
end
