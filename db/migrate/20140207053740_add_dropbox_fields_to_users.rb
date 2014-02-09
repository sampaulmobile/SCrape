class AddDropboxFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dropbox_id, :integer
    add_column :users, :dropbox_access_token, :string

    add_index :users, :dropbox_id, :unique => true
  end
end
