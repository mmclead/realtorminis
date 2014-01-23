class AddDreNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :dre_number, :string
  end
end
