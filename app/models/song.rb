class Song < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :playlists
	attr_accessible :title, :artist, :service, :song_id, :id
end
