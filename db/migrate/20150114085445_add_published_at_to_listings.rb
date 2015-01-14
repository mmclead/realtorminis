class AddPublishedAtToListings < ActiveRecord::Migration
  def change
    add_column :listings, :published_at, :datetime
  end
end
