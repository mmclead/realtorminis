class CreateDomainNames < ActiveRecord::Migration
  def change
    create_table :domain_names do |t|
      enable_extension "hstore"
      t.references :listing, index: true
      t.string :name
      t.string :source
      t.date :expiration_date
      t.hstore :details
      t.integer :status

      t.timestamps null: false
    end
    add_foreign_key :domain_names, :listings
  end
end
