class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :custom_url
      t.string :bucket
      t.boolean :active
      t.references :listing, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
