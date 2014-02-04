class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.integer :soundcloud_id
      t.string :soundcloud_username

      t.string :soundcloud_access_token
      t.string :soundcloud_refresh_token
      t.string :soundcloud_expires_at

      t.datetime :likes_last_updated
      t.boolean :is_active, default: true

      t.timestamps
    end

    add_index :users, :soundcloud_id, :unique => true
  end
end
