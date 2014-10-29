class CreateUserPhotos < ActiveRecord::Migration
  def change
    create_table :user_photos do |t|
      t.string :url
      t.references :user, index: true
      t.timestamps
    end
  end
end
