class AddListingIdToPhotos < ActiveRecord::Migration
  def change
    add_reference :photos, :listing, index: true
  end
end
