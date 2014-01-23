class AddWebSiteToUser < ActiveRecord::Migration
  def change
    add_column :users, :web_site, :string
  end
end
