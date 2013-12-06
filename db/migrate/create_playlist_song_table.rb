class PlaylistSong < ActiveRecord::Migration
	def change
		create_table :playlists_songs, :id => false do |t|
			t.references :playlist
			t.references :song
			t.timestamps
		end
	end
end
