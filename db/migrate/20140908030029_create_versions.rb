class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :name
      t.text :hipotesis
      t.string :blog_url

      t.timestamps
    end
  end
end
