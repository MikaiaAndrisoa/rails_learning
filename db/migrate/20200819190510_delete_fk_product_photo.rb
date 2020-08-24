class DeleteFkProductPhoto < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :photos, column: :product_id
  end
end
