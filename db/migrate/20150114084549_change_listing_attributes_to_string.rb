class ChangeListingAttributesToString < ActiveRecord::Migration
  def change
    change_column :listings, :price, :string
    change_column :listings, :bedrooms, :string
    change_column :listings, :sq_ft, :string
    change_column :listings, :bathrooms, :string
  end
end
