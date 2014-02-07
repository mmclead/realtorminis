class AddTagLineToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tag_line, :string
  end
end
