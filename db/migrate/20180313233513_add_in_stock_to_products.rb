class AddInStockToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :in_stock, :boolean
  end
end
