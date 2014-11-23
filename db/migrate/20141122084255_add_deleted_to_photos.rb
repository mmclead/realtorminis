class AddDeletedToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :deleted, :boolean, default: false
    add_column :photos, :deleted_at, :datetime
  end
end
