class AddCityStateZipToListing < ActiveRecord::Migration
  def change
    add_column :listings, :city, :string
    add_column :listings, :state, :string
    add_column :listings, :zip, :string
  end
end
