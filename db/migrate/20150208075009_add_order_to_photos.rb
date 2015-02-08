class AddOrderToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :order, :int
  end
end
