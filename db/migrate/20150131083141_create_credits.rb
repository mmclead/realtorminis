class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.references :account, index: true
      t.references :purchaseable, polymorphic: true, index: true
      t.datetime :spent_at
      t.datetime :purchased_at
      t.hstore :payment_details

      t.timestamps null: false
    end
    add_foreign_key :credits, :accounts
  end
end
