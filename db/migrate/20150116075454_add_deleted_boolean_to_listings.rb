class AddDeletedBooleanToListings < ActiveRecord::Migration
  def change
    add_column :listings, :deleted, :boolean
  end
end
