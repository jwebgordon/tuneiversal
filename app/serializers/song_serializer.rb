class SongSerializer < ActiveModel::Serializer
	attributes :id, :title, :artist, :service, :song_id
end
