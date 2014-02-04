class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|

      t.integer :soundcloud_id
      t.string :title
      t.string :download_url, default: ""
      t.integer :download_count, default: 0

      t.timestamps
    end
  end
end
