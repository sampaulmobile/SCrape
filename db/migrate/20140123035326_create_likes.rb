class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :track_id

      t.integer :try_count, default: 0
      t.boolean :downloaded, default: false
      t.boolean :downloading, default: false

      t.timestamps
    end
  end
end
