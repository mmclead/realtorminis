class AddActiveBooleanToListing < ActiveRecord::Migration
  def change
    add_column :listings, :active, :boolean, default: false
  end
end
