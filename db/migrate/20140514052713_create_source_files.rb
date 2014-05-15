class CreateSourceFiles < ActiveRecord::Migration
  def up
    drop_table :photos

    create_table :photos do |t|
      t.string :file_name
      t.string :file_content_type
      t.integer :file_size
      t.string :url
      t.string :key
      t.string :bucket

      t.timestamps
    end
  end

  def down

    drop_table :photos
    
    create_table "photos", force: true do |t|
      t.string   "photo"
      t.integer  "listing_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
