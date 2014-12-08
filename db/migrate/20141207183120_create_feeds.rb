class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :detail
      t.string :action
      t.string :type

      t.timestamps
    end

    create_table :feeds_users, :id => false do |t|
      t.integer :feed_id
      t.integer :user_id
    end
    add_index :feeds_users, [:feed_id, :user_id], :unique => true
  end
end
