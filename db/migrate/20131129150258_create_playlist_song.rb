class CreatePlaylistSong < ActiveRecord::Migration
	def self.up
		create_table :playlists_songs, :id => false do |t|
	 		t.references :playlist
	 		t.references :song
	 		t.timestamps
			end
	end

	def self.down
		drop_table :playlists_songs
	end
end