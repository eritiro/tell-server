class RemoveQr < ActiveRecord::Migration
  def change
    remove_column :locations, :afip_url, :string
  end
end
