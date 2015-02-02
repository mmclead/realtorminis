class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      enable_extension "hstore"
      t.references :user, index: true
      t.float :credits
      t.boolean :active
      t.hstore :settings

      t.timestamps null: false
    end
    add_foreign_key :accounts, :users
  end
end
