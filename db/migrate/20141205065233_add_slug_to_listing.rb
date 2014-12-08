class AddSlugToListing < ActiveRecord::Migration
  def change
    add_column :listings, :slug, :string, uniq: true
  end
end
