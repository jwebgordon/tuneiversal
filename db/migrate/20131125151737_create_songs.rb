class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :song_id
      t.string :title
      t.string :artist
      t.string :service

      t.timestamps
    end
  end
end
