class Removeimageurl < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :image_url_string
  end
end
