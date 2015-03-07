class CreateDomainNames < ActiveRecord::Migration
  def change
    create_table :domain_names do |t|
      t.references :listing, index: true
      t.string :name
      t.string :source
      t.date :expiration_date

      t.timestamps null: false
    end
    add_foreign_key :domain_names, :listings
  end
end
