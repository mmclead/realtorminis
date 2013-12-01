class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :address
      t.string :title
      t.integer :price
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :sq_ft
      t.string :web_address
      t.boolean :sold
      t.text :description
      t.string :short_description
      t.references :user, index: true

      t.timestamps
    end
  end
end
