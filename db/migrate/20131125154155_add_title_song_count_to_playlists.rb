class AddTitleSongCountToPlaylists < ActiveRecord::Migration
  def change
  	add_column :playlists, :title, :string
  	add_column :playlists, :song_count, :integer
  end
end
