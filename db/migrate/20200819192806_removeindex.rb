class Removeindex < ActiveRecord::Migration[5.2]
  def change
    remove_index :photos, column: :product_id
  end
end
