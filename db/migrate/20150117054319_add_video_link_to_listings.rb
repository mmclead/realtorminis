class AddVideoLinkToListings < ActiveRecord::Migration
  def change
    add_column :listings, :video_link, :text
  end
end
