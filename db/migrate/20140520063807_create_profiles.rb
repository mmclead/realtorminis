class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.string :profile_pic
      t.string :logo
      t.string :name
      t.string :web_site
      t.string :contact_email
      t.string :phone_number
      t.string :dre_number
      t.text :tag_line

      t.timestamps
    end

    change_table :users do |t|
      t.remove :profile_pic
      t.remove :logo
      t.remove :name
      t.remove :web_site
      t.remove :contact_email
      t.remove :phone_number
      t.remove :dre_number
      t.remove :tag_line
    end
  end
end
