class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text
      t.decimal :score, precision: 4, scale: 1
      t.references :user, index: true

      t.timestamps
    end
  end
end
