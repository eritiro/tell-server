class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :type
      t.references :from, index: true
      t.references :to, index: true
      t.string :text

      t.timestamps
    end
  end
end
