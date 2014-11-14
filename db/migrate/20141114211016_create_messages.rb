class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :from, index: true
      t.references :to, index: true
      t.string :text

      t.timestamps
    end
  end
end
