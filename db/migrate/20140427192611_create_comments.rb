class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :text
      t.decimal :score, precision: 4, scale: 1
      t.references :user, index: true

      t.timestamps
    end
  end
end
