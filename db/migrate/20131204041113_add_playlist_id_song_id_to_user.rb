class AddPlaylistIdSongIdToUser < ActiveRecord::Migration
  def change
  	add_column :users, :playlist_id, :integer
  	add_column :users, :song_id, :integer
  end
end
