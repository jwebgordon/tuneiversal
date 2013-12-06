class AddUserIdToPlaylistsAddUserIdToSongs < ActiveRecord::Migration
  def change
  	add_column :playlists, :user_id, :integer
  	add_column :songs, :user_id, :integer
  end
end
