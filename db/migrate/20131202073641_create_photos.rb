class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :photo
      t.references :listing, index: true

      t.timestamps
    end
  end
end
